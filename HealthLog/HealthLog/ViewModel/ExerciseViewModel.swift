//
//  ExerciseViewModel.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import RealmSwift
import Foundation


class ExerciseViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var realm: Realm?
    private var exercisesNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    // 운동부위옵션을 열고 닫을때 쓰는 상태값
    @Published var bodypartOptionShow: Bool = false
    
    // 검색 상태값
    @Published var searchText: String = ""
    @Published var selectedOption: BodyPartOption = .all
    
    // 검색 결과 상태값
    @Published var exercises: [Exercise] = []
    @Published var filteredExercises: [Exercise] = []

    
    // MARK: - Init
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        setupBindings()
    }
    
    deinit {
        exercisesNotificationToken?.invalidate()
    }
    
    // Realm 데이터 -> Combine Published 변수
    private func observeRealmData() {
        guard let realm = realm else {return} // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        let results = realm.objects(Exercise.self)
            .filter("isDeleted == false")
        
        exercisesNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
//                    print("results.observe exericse - initial")
                    self?.exercises = Array(collection)
                case .update(let collection, _, _, _):
//                    print("results.observe exericse - update")
                    self?.exercises = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupBindings() {
        // MARK: Sync filteredExercises
        $exercises.assign(to: &$filteredExercises)
        
        // MARK: Search Exercises Filter
        // TODO: RunLoop 대신할꺼 있나 찾아보기
        // 검색 키워드, 운동부위 변경시마다 검색결과 필터링
        Publishers.CombineLatest(
            $searchText.throttle(
                for: .milliseconds(99),
                scheduler: RunLoop.main, latest: true),
            $selectedOption.throttle(
                for: .milliseconds(99),
                scheduler: RunLoop.main, latest: true)
        )
        .sink { [weak self] _ in
            self?.filterExercises()
        }
        .store(in: &cancellables)
        
    }
    
    // MARK: - Methods
    
    // (사용 안함) 검색 키워드만 필터링
    func filterExercises(by searchText: String) {
        if searchText.isEmpty {
            filteredExercises = exercises
        } else {
            filteredExercises = exercises.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    // (사용 중) 검색 키워드 + 운동 부위로 필터링
    func filterExercises() {
//        print("filterExercises - \(String(describing: selectedOption))")
        
        // 검색어와 부위를 기반으로 운동리스트를 필터링
        filteredExercises = exercises.filter { exercise in
            
            // 검색어 체크
            let matchesAll = searchText.isEmpty
            let matchesSearchText  = exercise.name
                .localizedCaseInsensitiveContains(searchText)
            let isSearchText = matchesAll || matchesSearchText
            
            // 운동부위 체크
            let isBodyPart: Bool
            switch selectedOption {
                case .all:
                    isBodyPart = true
                case .bodyPart(let bodyPart):
                    isBodyPart = exercise.bodyParts.contains(bodyPart)
            }
            
            // 이 운동이 검색어와 선택한 운동 부위에 해당하는가
            return isSearchText && isBodyPart
        }
    }
    
    
    // MARK: - Setter
    
    func setOption(to option: BodyPartOption) {
        selectedOption = option
//        print("setOption - \(selectedOption)")
    }
    
    func setSearchText(to text: String) {
        searchText = text
    }
}

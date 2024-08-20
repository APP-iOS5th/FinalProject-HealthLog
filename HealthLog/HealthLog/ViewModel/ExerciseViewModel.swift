//
//  ViewModel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Combine
import RealmSwift
import Foundation

class ExerciseViewModel: ObservableObject {
    private var realm: Realm
    private var exercisesNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var searchText: String = ""
    @Published private(set) var selectedOption: BodyPartOption = .all
    
    @Published private(set) var exercises: [Exercise] = []
    @Published private(set) var filteredExercises: [Exercise] = []
    
    @Published var exercise: Exercise = Exercise()
    @Published private(set) var exerciseName: String = ""
    @Published private(set) var isDuplicateExerciseName: Bool = false
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        subjectExercises()
        subjectSearchExercises()
    }
    
    deinit {
        exercisesNotificationToken?.invalidate()
    }
    
    private func observeRealmData() {
        let results = realm.objects(Exercise.self)
        
        exercisesNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
                    print("results.observe - initial")
                    self?.exercises = Array(collection)
                case .update(let collection, _, _, _):
                    print("results.observe - update")
                    self?.exercises = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    private func subjectExercises() {
        // realm의 observe가 exercises를 갱신시 assign
        $exercises.assign(to: &$filteredExercises)
    }
    
    private func subjectSearchExercises() {
        Publishers.CombineLatest(
            $searchText.throttle(
                for: .milliseconds(99), 
                scheduler: RunLoop.main, latest: true),
            $selectedOption
        )
        .sink { [weak self] _ in self?.filterExercises() }
        .store(in: &cancellables)
    }
    
    func filterExercises(by searchText: String) {
        if searchText.isEmpty {
            filteredExercises = exercises
        } else {
            filteredExercises = exercises.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func filterExercises() {
        // 검색어와 부위를 기반으로 운동리스트를 필터링
        filteredExercises = exercises.filter { exercise in
            
            // 검색어
            let matchesAll = searchText.isEmpty
            let matchesSearchText  = exercise.name
                .localizedCaseInsensitiveContains(searchText)
            let isSearchText = matchesAll || matchesSearchText
            
            // 부위
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
    
    func checkDuplicateExerciseName(to name: String) {
        isDuplicateExerciseName = exercises.contains {$0.name == name}
    }
    
    // MARK: - Setter
    
    func setOption(to option: BodyPartOption) {
        selectedOption = option
    }
    
    func setSearchText(to text: String) {
        searchText = text
    }
    
}

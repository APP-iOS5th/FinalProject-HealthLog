//
//  ViewModel.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import RealmSwift
import Foundation


class ExerciseViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var realm: Realm
    private var exercisesNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    // 운동부위옵션을 열고 닫을때 쓰는 상태값
    @Published var bodypartOptionShow: Bool = false
    
    // 검색 상태값
    @Published private(set) var searchText: String = ""
    @Published var selectedOption: BodyPartOption = .all
    
    // 검색 결과 상태값
    @Published private(set) var exercises: [Exercise] = []
    @Published private(set) var filteredExercises: [Exercise] = []
    
    // 입력용 Object
    @Published var exercise = InputExerciseObject()
    
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
            print("Search Exercises Filter - \(String(describing: self?.selectedOption))")
            self?.filterExercises()
        }
        .store(in: &cancellables)

        // MARK: Check Duplicate Name
        // 운동 이름 중복 체크
        exercise.$name
            .sink { self.checkDuplicateExerciseName(to: $0) }
            .store(in: &cancellables)
        
        // MARK: Test - Check RequiredExerciseFields Empty
        // 입력 필수요소 유효성 검사
        Publishers.CombineLatest(exercise.$name, exercise.$bodyParts)
            .sink { exerciseName, exerciseBodyParts in
                self.validateRequiredFields(exerciseName: exerciseName, exerciseBodyParts: exerciseBodyParts)
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
        print("filterExercises - \(String(describing: selectedOption))")
        
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
        exercise.hasDuplicateExerciseName = exercises.contains {$0.name == name}
    }
    
    func validateRequiredFields(exerciseName: String, exerciseBodyParts: [BodyPart]) {
        
        print("name - \(exerciseName.isEmpty) bodypart - \(exerciseBodyParts.isEmpty)") // log
        
        exercise.isExerciseNameEmpty = exerciseName.isEmpty
        exercise.isExerciseBodyPartsEmpty = exerciseBodyParts.isEmpty
        
        // 운동 이름 중복 여부
        if exercise.hasDuplicateExerciseName {
            exercise.isValidatedRequiredExerciseFields = false
            print("isValidatedRequiredExerciseFields - \(exercise.isValidatedRequiredExerciseFields)") // log
            return
        }
        
        // 운동 이름 비어있는지 여부
        if exercise.isExerciseNameEmpty {
            exercise.isValidatedRequiredExerciseFields = false
            print("isValidatedRequiredExerciseFields - \(exercise.isValidatedRequiredExerciseFields)") // log
            return
        }
        
        // 운동 부위 비어있는지 여부
        if exercise.isExerciseBodyPartsEmpty {
            exercise.isValidatedRequiredExerciseFields = false
            print("isValidatedRequiredExerciseFields - \(exercise.isValidatedRequiredExerciseFields)") // log
            return
        }
        
        // 필수 요소 체크 끝, 정상이므로 true
        exercise.isValidatedRequiredExerciseFields = true
        print("isValidatedRequiredExerciseFields - \(exercise.isValidatedRequiredExerciseFields)") // log
    }
    
    func realmWriteExercise() {
        // 필수 요소 확인
        if !exercise.isValidatedRequiredExerciseFields {
            print("realmWriteExercise - isValidatedRequiredExerciseFields")
            return
        }
        
        try! realm.write {
            realm.add(exercise.addRealmExerciseObject())
        }
        
        exercise.initInputExercise()
    }
    
    // MARK: - Setter
    
    func setOption(to option: BodyPartOption) {
        selectedOption = option
        print("setOption - \(selectedOption)")
    }
    
    func setSearchText(to text: String) {
        searchText = text
    }
}


class InputExerciseObject: ObservableObject {
    @Published var name: String = ""
    @Published var bodyParts: [BodyPart] = []
    @Published var recentWeight: Int = 0
    @Published var maxWeight: Int = 0
    @Published var description: String = ""
    
    @Published var isValidatedRequiredExerciseFields: Bool = false
    @Published var hasDuplicateExerciseName: Bool = false
    @Published var isExerciseNameEmpty: Bool = true
    @Published var isExerciseBodyPartsEmpty: Bool = true
    
    func initInputExercise() {
        name = ""
        bodyParts = []
        recentWeight = 0
        maxWeight = 0
        description = ""
        
        isValidatedRequiredExerciseFields = false
        hasDuplicateExerciseName = false
        isExerciseNameEmpty = true
        isExerciseBodyPartsEmpty = true
    }
    
    func addRealmExerciseObject() -> Exercise {
        return Exercise(
            name: name,
            bodyParts: bodyParts,
            descriptionText: description,
            image: nil,
            totalReps: 0,
            recentWeight: recentWeight,
            maxWeight: maxWeight,
            isCustom: true
        )
    }
}

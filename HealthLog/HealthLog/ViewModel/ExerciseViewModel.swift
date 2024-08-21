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
    
    @Published var inputExerciseObject = InputExerciseObject()
    @Published var exerciseName: String = ""
    @Published var exerciseBodyParts: [BodyPart] = []
    @Published var exerciseRecentWeight: Int = 0
    @Published var exerciseMaxWeight: Int = 0
    @Published var exerciseDescription: String = ""
    
    @Published var isValidatedRequiredExerciseFields: Bool = true
    @Published var hasDuplicateExerciseName: Bool = false
    @Published var isExerciseNameEmpty: Bool = true
    @Published var isExerciseBodyPartsEmpty: Bool = true
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        setupBindings()
        
        // TODO: 임시용 bodyParts
        exerciseBodyParts = [.abductors]
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
    
    private func setupBindings() {
        // MARK: Sync filteredExercises
        $exercises.assign(to: &$filteredExercises)

        // MARK: Search Exercises Filter
        Publishers.CombineLatest(
            $searchText.throttle(
                for: .milliseconds(99),
                scheduler: RunLoop.main, latest: true),
            $selectedOption
        )
        .sink { [weak self] _ in self?.filterExercises() }
        .store(in: &cancellables)

        // MARK: Check RequiredExerciseFields Empty
//        Publishers.CombineLatest($exerciseName, $exerciseBodyParts)
//            .sink { exerciseName, exerciseBodyParts in
//                print("name - \(exerciseName.isEmpty) bodypart - \(exerciseBodyParts.isEmpty)") // log
//                
//                self.isExerciseNameEmpty = exerciseName.isEmpty
//                self.isExerciseBodyPartsEmpty = exerciseBodyParts.isEmpty
//                self.validateRequiredFields()
//            }
//            .store(in: &cancellables)
        
        // MARK: Test - Check RequiredExerciseFields Empty
        $inputExerciseObject
            .sink {
                print("name - \($0.name.isEmpty) bodypart - \($0.bodyParts.isEmpty)") // log
                
                self.isExerciseNameEmpty = $0.name.isEmpty
                self.isExerciseBodyPartsEmpty = $0.bodyParts.isEmpty
                self.validateRequiredFields()
            }
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
        hasDuplicateExerciseName = exercises.contains {$0.name == name}
    }
    
    func validateRequiredFields() {
        if hasDuplicateExerciseName { return }
        if isExerciseNameEmpty { return }
        if isExerciseBodyPartsEmpty { return }
        
        isValidatedRequiredExerciseFields = true
        print("isValidatedRequiredExerciseFields - \(isValidatedRequiredExerciseFields)") // log
    }
    
    func realmWriteExercise() {
        if !isValidatedRequiredExerciseFields {
            print("realmWriteExercise - isValidatedRequiredExerciseFields")
            return
        }
        
        let exercise: Exercise = Exercise(
            name: exerciseName,
            bodyParts: exerciseBodyParts,
            descriptionText: exerciseDescription,
            image: nil,
            totalReps: 0,
            recentWeight: exerciseRecentWeight,
            maxWeight: exerciseMaxWeight,
            isCustom: true
        )
        
        try! realm.write {
            realm.add(inputExerciseObject.addRealmExerciseObject())
        }
        
        exerciseName = ""
        exerciseBodyParts = []
        exerciseRecentWeight = 0
        exerciseMaxWeight = 0
        exerciseDescription = ""
    }
    
    // MARK: - Setter
    
    func setOption(to option: BodyPartOption) {
        selectedOption = option
    }
    
    func setSearchText(to text: String) {
        searchText = text
    }
    
    func initInputExercise() {
        exerciseName = ""
        exerciseBodyParts = []
        exerciseRecentWeight = 0
        exerciseMaxWeight = 0
        exerciseDescription = ""
    }
}


class InputExerciseObject: ObservableObject {
    @Published var name: String = ""
    @Published var bodyParts: [BodyPart] = []
    @Published var recentWeight: Int = 0
    @Published var maxWeight: Int = 0
    @Published var description: String = ""
    
    // Exercise 객체의 상태를 변경하는 메서드
    func update(name: String, bodyParts: [BodyPart]) {
        self.name = name
        self.bodyParts = bodyParts
    }
    
    func initInputExercise() {
        name = ""
        bodyParts = []
        recentWeight = 0
        maxWeight = 0
        description = ""
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

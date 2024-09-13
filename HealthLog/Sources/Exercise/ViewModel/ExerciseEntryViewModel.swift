//
//  ExerciseEntryViewModel.swift
//  HealthLog
//
//  Created by user on 8/24/24.
//

import Foundation
import RealmSwift
import Combine

enum ExerciseEntryViewMode {
    case add
    case update(ExerciseDetailViewModel)
}

class ExerciseEntryViewModel {
    private let realm = RealmManager.shared.realm
    private var cancellables = Set<AnyCancellable>()
    var viewModel: ExerciseViewModel
    
    // ExerciseEntryViewController의 입력 모드
    let mode: ExerciseEntryViewMode
    
    // 첫 실행 이후 (4회 이상부터) 부터 동작하게 하기위한 카운트
    var warningCount = 0
    
    // 입력용 Object
    @Published var entryExercise = EntryExercise()
    
    // MARK: Init
    
    init(mode: ExerciseEntryViewMode, viewModel: ExerciseViewModel) {
        self.mode = mode
        self.viewModel = viewModel
        
        setupBindings()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        // MARK: Check Duplicate Name
        // 운동 이름 중복 체크
        entryExercise.$name
            .sink { self.checkDuplicateExerciseName(to: $0) }
            .store(in: &cancellables)
        
        // MARK: Test - Check RequiredExerciseFields Empty
        // 입력 필수요소 유효성 검사
        Publishers.CombineLatest(
            entryExercise.$name, entryExercise.$bodyParts)
        .sink { exerciseName, exerciseBodyParts in
            self.validateRequiredFields(
                exerciseName: exerciseName,
                exerciseBodyParts: exerciseBodyParts)
        }
        .store(in: &cancellables)
    }
    
    // MARK: Methods
    
    private func checkDuplicateExerciseName(to name: String) {
        var result: Bool
        switch mode {
            case .add :
                result = viewModel.exercises.contains { $0.name == name }
            case .update(let detailViewModel) :
                result = viewModel.exercises.contains { $0.name == name }
                result = result && detailViewModel.exercise.name != name
        }
        
        entryExercise.hasDuplicateName = result
    }
    
    private func validateRequiredFields(
        exerciseName: String, exerciseBodyParts: [BodyPart]) {
            
            entryExercise.isNameEmpty = exerciseName.isEmpty
            entryExercise.isBodyPartsEmpty = exerciseBodyParts.isEmpty
            
            // 운동 이름 중복 여부
            if entryExercise.hasDuplicateName {
                entryExercise.isValidatedRequiredFields = false
//                print("isValidatedRequiredExerciseFields - \(entryExercise.isValidatedRequiredFields)") // log
                return
            }
            
            // 운동 이름 비어있는지 여부
            if entryExercise.isNameEmpty {
                entryExercise.isValidatedRequiredFields = false
//                print("isValidatedRequiredExerciseFields - \(entryExercise.isValidatedRequiredFields)") // log
                return
            }
            
            // 운동 부위 비어있는지 여부
            if entryExercise.isBodyPartsEmpty {
                entryExercise.isValidatedRequiredFields = false
//                print("isValidatedRequiredExerciseFields - \(entryExercise.isValidatedRequiredFields)") // log
                return
            }
            
            // 필수 요소 체크 끝, 정상이면 true
            entryExercise.isValidatedRequiredFields = true
//            print("isValidatedRequiredExerciseFields - \(entryExercise.isValidatedRequiredFields)") // log
        }
    
    // MARK: - Realm Methods
    
    func realmAddExercise() {
        guard let realm = realm else { return } // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        // 필수 요소 확인
        guard entryExercise.isValidatedRequiredFields else {
            print("realmWriteExercise - 필수 입력 불충족")
            return
        }
        
        realm.writeAsync() { // 이부분 try! 강제 언래핑 지울 방법 있을 까요?
            realm.add(self.entryExercise.addRealmExerciseObject())
        }
    }
        

    func realmExerciseIsDeleted() {
        guard case .update(let detailViewModel) = mode
        else { return }
        let exercise = detailViewModel.exercise
        guard let realm = realm else { return } // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        realm.writeAsync() {
            exercise.isDeleted = true
        }
    }
    
    // TODO: 작성중
    func realmUpdateExercise() {
        guard case .update(let detailViewModel) = mode 
        else { return }
        let exercise = detailViewModel.exercise
        let data = entryExercise
        
        let images: [ExerciseImage] = data.images.map { image in
            ExerciseImage(image: image, url: nil, urlAccessCount: nil)
        }
        
        guard let realm = realm else { return }
        do {
            try realm.write {
                update(&exercise.name, with: data.name)
                updateList(exercise.bodyParts, with: data.bodyParts)
                update(&exercise.recentWeight, with: data.recentWeight)
                update(&exercise.maxWeight, with: data.maxWeight)
                update(&exercise.descriptionText, with: data.description)
                updateImages(exercise.images, with: images)
            }
        } catch {
            print("realm exercise update error")
        }
        
    }

    private func update<T: Equatable>(_ property: inout T, with newValue: T) {
        if property != newValue {
//            print("realmUpdateExercise update - \(newValue)")
            property = newValue
        }
    }
    
    private func updateList<T: Equatable>(_ property: List<T>, with newValue: [T]) {
        if !property.elementsEqual(newValue) {
//            print("realmUpdateExercise updateList - \(newValue)")
            property.removeAll()
            property.append(objectsIn: newValue)
        }
    }
    
    private func updateImages<T: ExerciseImage>(_ property: List<T>, with newValue: [T]) {
        let oldValue = Array(property) as [ExerciseImage]
        let equalImages = zip(oldValue, newValue).allSatisfy { $0.image == $1.image }
        if !equalImages || oldValue.count == 0 {
//            print("realmUpdateExercise updateImages - \(newValue)")
            property.removeAll()
            property.append(objectsIn: newValue)
        }
    }
    
}

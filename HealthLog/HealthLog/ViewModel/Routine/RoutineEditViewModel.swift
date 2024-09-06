//
//  RoutineEditViewModel.swift
//  HealthLog
//
//  Created by 어재선 on 8/31/24.
//

import Foundation
import Combine
import RealmSwift

class RoutineEditViewModel {
    
    private var realm: Realm?
    private var realmManager = RealmManager.shared
    
    @Published var routine: Routine = Routine()
    
    @Published var isAddRoutineValid: Bool = false
    @Published var isValid:Bool = false
    @Published var editNameTextField = ""
    @Published var routineExecrises: [RoutineExercise] = []
    
    lazy var isRoutineNameEmptyPulisher:
    AnyPublisher<Bool, Never> = {
        $editNameTextField
            .map(\.isEmpty)
            .eraseToAnyPublisher()
    }()
    
    lazy var isRoutineNameMatchingPulisher:
    AnyPublisher<Bool, Never> = {
        $editNameTextField
            .map {
                self.realmManager.hasRoutineName(name: $0)
            }
            .eraseToAnyPublisher()
        
    }()
        
    // 세트 수 업데이트
    func updateExerciseSetCount(for index: Int, setCount: Int) {
        if self.routineExecrises[index].sets.count < setCount {
                self.routineExecrises[index].sets.append(RoutineExerciseSet(order: setCount, weight: -1, reps: -1))
        } else {
                self.routineExecrises[index].sets.removeLast()

        }
        validateExercise()
    }
    
    // 운동 순서 이동
    func moveExercise(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let exercise =  routineExecrises.remove(at: sourceIndex)
        routineExecrises.insert(exercise, at: destinationIndex)
        
        for (index, exercise) in routineExecrises.enumerated() {
            exercise.order = index
        }
        validateExercise()
    }
    
    // 운동 삭제
    func deleteExercise(at index: Int) {
        guard index < routineExecrises.count else { return }
        
        self.routineExecrises.remove(at: index)
        validateExercise()
    }
    
    func updateRoutine(routine: Routine, index: Int) {
        var volume: Int = 0
        for exercise in routine.exercises {
            for sets in exercise.sets {
                volume += sets.weight * sets.reps
            }
        }
        routine.exerciseVolume = volume
        self.realmManager.updetaRoutine(newRoutine: routine, index: index)
    }
    
    func deleteRoutine(id: ObjectId){
        self.realmManager.deleteRoutine(id: id)
        
    }
    
    func validateExercise() {
        let isExercise = !routine.exercises.isEmpty

        let allFieldsFilled = routine.exercises.allSatisfy { exercise in
            exercise.sets.allSatisfy { set in
                set.weight >= 0 && set.reps > 0
            }
        }
        let isName = !self.editNameTextField.isEmpty
        var isMatcing = self.realmManager.hasRoutineName(name: self.editNameTextField)
        let isNowNameMatching = routine.name == self.editNameTextField
        if isNowNameMatching {
           isMatcing = false
        }
        
        
        isAddRoutineValid = isExercise && allFieldsFilled && !isMatcing && isName
        print(isAddRoutineValid)

    }
    
    
    func getRoutine(routine: Routine) {
        self.routine.name = routine.name
        for routineExercise in routine.exercises {
            var routineSets: [RoutineExerciseSet] = []
            for sets in routineExercise.sets {
                routineSets.append(RoutineExerciseSet(order: sets.order, weight: sets.weight, reps: sets.reps))
            }
            if let exercise = routineExercise.exercise {
                self.routine.exercises.append(RoutineExercise(exercise: exercise, order: routineExercise.order, sets: routineSets))
            } else {
                print("error: 운동이 없음")
            }
        }
        self.routine.exerciseVolume = routine.exerciseVolume
    }
    
    
}

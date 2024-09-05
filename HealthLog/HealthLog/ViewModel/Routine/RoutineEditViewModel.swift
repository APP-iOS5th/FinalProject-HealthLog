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
        
    func updateExerciseSetCount(for section: Int, setCount: Int) {
        if self.routine.exercises[section].sets.count < setCount {
            
            self.routine.exercises[section].sets.append(RoutineExerciseSet(order: setCount, weight: 0, reps: 0))
            
        } else {
            self.routine.exercises[section].sets.removeLast()
        }
        validateExercise()
    }
 
    func deleteExercise(for setcion: Int) {
        self.routine.exercises.remove(at: setcion)
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
        print("routineName\(routine.name)")
        print("editNameTextField\(self.editNameTextField)")
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
                self.routine.exercises.append(RoutineExercise(exercise: exercise, sets: routineSets))
            } else {
                print("error: 운동이 없음")
            }
        }
        self.routine.exerciseVolume = routine.exerciseVolume
    }
    
    
}

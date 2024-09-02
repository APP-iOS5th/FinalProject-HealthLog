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
    
    @Published var routine: Routine = Routine()
    private var routines: [Routine] = []
    
    init() {
        
    }
    
    
    func updateExerciseSetCount(for section: Int, setCount: Int) {
        print(self.routine.exercises[section].sets.count)
        print(setCount)
        if self.routine.exercises[section].sets.count < setCount {
            
            self.routine.exercises[section].sets.append(RoutineExerciseSet(order: setCount, weight: 0, reps: 0))
            
        } else {
            self.routine.exercises[section].sets.removeLast()
            
        }
        
    }
    
    func deleteExercise(for setcion: Int) {
        self.routine.exercises.remove(at: setcion)
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

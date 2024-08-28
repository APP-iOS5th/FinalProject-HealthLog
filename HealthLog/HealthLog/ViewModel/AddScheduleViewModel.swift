//
//  AddScheduleViewModel.swift
//  HealthLog
//
//  Created by seokyung on 8/20/24.
//

import Combine
import Foundation
import RealmSwift

class AddScheduleViewModel {
    @Published var selectedExercises: [ScheduleExercise] = []
    @Published var isValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func addExercise(_ exercise: Exercise) {
        let setCount = 4
        let sets = (1...setCount).map { order in
            ScheduleExerciseSet(
                order: order, weight: 0, reps: 0, isCompleted: false)
        }
        
        let scheduleExercise = ScheduleExercise(exercise: exercise, order: selectedExercises.count, isCompleted: false, sets: sets)
        selectedExercises.append(scheduleExercise)
        validateExercises()
    }
    
    func addExercises(from routine: Routine) {
        let convertedExercises = routine.exercises.compactMap { routineExercise -> ScheduleExercise? in
            guard let exercise = routineExercise.exercise else { return nil }
            
            let sets = routineExercise.sets.map { routineSet in
                ScheduleExerciseSet(order: routineSet.order, weight: routineSet.weight, reps: routineSet.reps, isCompleted: false)
            }
            
            return ScheduleExercise(exercise: exercise, order: self.selectedExercises.count, isCompleted: false, sets: Array(sets))
        }
        
        selectedExercises.append(contentsOf: convertedExercises)
        validateExercises()
    }
    
    func updateExerciseSetCount(for index: Int, setCount: Int) {
        //print("setCount-\(setCount)--count-\(selectedExercises[index].sets.count)")
        if(setCount > selectedExercises[index].sets.count) {
            //print("--append--)")
            let set = ScheduleExerciseSet(
                order: setCount, weight: 0, reps: 0, isCompleted: false)
            selectedExercises[index].sets.append(set)
        } else if (setCount < selectedExercises[index].sets.count) {
            //print("--delete--")
            selectedExercises[index].sets.removeLast()
        }
        validateExercises()
    }
    
    func updateSet(at exerciseIndex: Int, setIndex: Int, weight: Int, reps: Int) {
        guard exerciseIndex < selectedExercises.count,
              setIndex < selectedExercises[exerciseIndex].sets.count else { return }
        
        selectedExercises[exerciseIndex].sets[setIndex].weight = weight
        selectedExercises[exerciseIndex].sets[setIndex].reps = reps
        validateExercises()
    }
    
    func moveExercise(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let exercise = selectedExercises.remove(at: sourceIndex)
        selectedExercises.insert(exercise, at: destinationIndex)
        
        for (index, exercise) in selectedExercises.enumerated() {
            exercise.order = index
        }
        
        validateExercises()
    }
    
    private func validateExercises() {
        let exercisesExist = !selectedExercises.isEmpty
        let allFieldsFilled = selectedExercises.allSatisfy { exercise in
            exercise.sets.allSatisfy { set in
                set.weight > 0 && set.reps > 0
            }
        }
        let noEmptyFields = selectedExercises.allSatisfy { exercise in
            exercise.sets.allSatisfy { set in
                set.weight != 0 && set.reps != 0
            }
        }
        isValid = exercisesExist && allFieldsFilled && noEmptyFields
    }
    
    func removeExercise(at index: Int) {
        guard index < selectedExercises.count else { return }
        selectedExercises.remove(at: index)
        validateExercises()
    }
    
    func saveSchedule(for date: Date) {
        let schedule = Schedule(date: date, exercises: selectedExercises)
        print(schedule) // 생성된 데이터 확인
    }
}

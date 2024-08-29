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
    private var realm: Realm?
    
    init() {
        self.realm = RealmManager.shared.realm
    }
    
    func addExercise(_ exercise: Exercise) {
        let setCount = 4
        let sets = (1...setCount).map { order in
            ScheduleExerciseSet(
                order: order, weight: 0, reps: 0, isCompleted: false)
        }
        
        let scheduleExercise = ScheduleExercise(exercise: exercise, order: selectedExercises.count + 1, isCompleted: false, sets: sets)
        selectedExercises.append(scheduleExercise)
        validateExercises()
    }
    
    func addExercises(from routine: Routine) {
        let convertedExercises = routine.exercises.compactMap { routineExercise -> ScheduleExercise? in
            guard let exercise = routineExercise.exercise else { return nil }
            
            let sets = routineExercise.sets.map { routineSet in
                ScheduleExerciseSet(order: routineSet.order, weight: routineSet.weight, reps: routineSet.reps, isCompleted: false)
            }
            
            return ScheduleExercise(exercise: exercise, order: self.selectedExercises.count + 1, isCompleted: false, sets: Array(sets))
        }
        
        selectedExercises.append(contentsOf: convertedExercises)
        validateExercises()
    }
    
    func updateExerciseSetCount(for index: Int, setCount: Int) {
        if(setCount > selectedExercises[index].sets.count) {
            let set = ScheduleExerciseSet(
                order: setCount + 1, weight: 0, reps: 0, isCompleted: false)
            selectedExercises[index].sets.append(set)
        } else if (setCount < selectedExercises[index].sets.count) {
            selectedExercises[index].sets.removeLast()
        }
        validateExercises()
    }
    
    func updateSet(at exerciseIndex: Int, setIndex: Int, weight: Int, reps: Int) {
        guard exerciseIndex < selectedExercises.count,
              setIndex < selectedExercises[exerciseIndex].sets.count else { return }
        guard let realm = realm else { return }
        try! realm.write {
            selectedExercises[exerciseIndex].sets[setIndex].weight = weight
            selectedExercises[exerciseIndex].sets[setIndex].reps = reps
        }
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
        isValid = exercisesExist && allFieldsFilled
    }
    
    func removeExercise(at index: Int) {
        guard index < selectedExercises.count else { return }
        selectedExercises.remove(at: index)
        validateExercises()
    }
    
    func saveSchedule(for date: Date) {
        guard let realm = realm else { return }
        // 특정 날짜에 해당하는 스케줄 검색
        if let existingSchedule = realm.objects(Schedule.self).filter("date == %@", date).first {
            // 스케줄이 이미 있는 경우, 운동을 추가
            try! realm.write {
                existingSchedule.exercises.append(objectsIn: selectedExercises)
            }
            // print("Existing schedule found and updated with new exercises.")
        } else {
            // 스케줄이 없는 경우, 새로운 스케줄 생성 및 저장
            let newSchedule = Schedule(date: date, exercises: selectedExercises)
            try! realm.write {
                realm.add(newSchedule)
            }
            // print("New schedule created and saved.")
        }
    }
}

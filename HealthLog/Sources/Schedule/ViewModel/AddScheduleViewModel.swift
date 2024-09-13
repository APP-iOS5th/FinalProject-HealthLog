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
    private let realmManager = RealmManager.shared
    
    // 운동 추가
    func addExercise(_ exercise: Exercise) {
        if let recentSets = getRecentRecord(for: exercise) {
            let scheduleExercise = ScheduleExercise(exercise: exercise, order: selectedExercises.count + 1, isCompleted: false, sets: recentSets)
            selectedExercises.append(scheduleExercise)
        } else {
            let setCount = 4
            let sets = (1...setCount).map { order in
                ScheduleExerciseSet(
                    order: order, weight: -1, reps: -1, isCompleted: false)
            }
            let scheduleExercise = ScheduleExercise(exercise: exercise, order: selectedExercises.count + 1, isCompleted: false, sets: sets)
            selectedExercises.append(scheduleExercise)
        }
        validateExercises()
    }
    
    // 루틴 추가
    func addExercises(from routine: Routine) {
        let startingOrder = selectedExercises.count + 1
        let convertedExercises = routine.exercises.enumerated().compactMap { index, routineExercise -> ScheduleExercise? in
            guard let exercise = routineExercise.exercise else { return nil }
            
            let sets = routineExercise.sets.map { routineSet in
                ScheduleExerciseSet(order: routineSet.order, weight: routineSet.weight, reps: routineSet.reps, isCompleted: false)
            }
            
            return ScheduleExercise(exercise: exercise, order: startingOrder + index, isCompleted: false, sets: Array(sets))
        }
        selectedExercises.append(contentsOf: convertedExercises)
        validateExercises()
    }
    
    // 최근 기록 불러오기
    private func getRecentRecord(for exercise: Exercise) -> [ScheduleExerciseSet]? {
        guard let realm = realmManager.realm else { return nil }
        
        let recentSchedule = realm.objects(Schedule.self)
            .filter("ANY exercises.exercise == %@", exercise)
            .sorted(byKeyPath: "date", ascending: false)
            .first
        
        return recentSchedule?.exercises
            .filter("exercise == %@", exercise)
            .first?
            .sets
            .map { ScheduleExerciseSet(order: $0.order, weight: $0.weight, reps: $0.reps, isCompleted: false) }
    }
    
    // 세트 수 업데이트
    func updateExerciseSetCount(for index: Int, setCount: Int) {
        if(setCount > selectedExercises[index].sets.count) {
            let set = ScheduleExerciseSet(
                order: setCount + 1, weight: -1, reps: -1, isCompleted: false)
            selectedExercises[index].sets.append(set)
        } else if (setCount < selectedExercises[index].sets.count) {
            selectedExercises[index].sets.removeLast()
        }
        validateExercises()
    }
    
    // 세트의 무게 횟수 업데이트
    func updateSet(at exerciseIndex: Int, setIndex: Int, weight: Int, reps: Int) {
        realmManager.updateSet(selectedExercises: selectedExercises, at: exerciseIndex, setIndex: setIndex, weight: weight, reps: reps)
        validateExercises()
    }
    
    // 운동 순서 이동
    func moveExercise(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        
        let exercise = selectedExercises.remove(at: sourceIndex)
        selectedExercises.insert(exercise, at: destinationIndex)
        
        for (index, exercise) in selectedExercises.enumerated() {
            exercise.order = index
        }
        validateExercises()
    }
    
    // 완료 버튼 유효성 확인
    private func validateExercises() {
        let exercisesExist = !selectedExercises.isEmpty
        let allFieldsFilled = selectedExercises.allSatisfy { exercise in
            exercise.sets.allSatisfy { set in
                set.reps > 0 && set.weight >= 0
            }
        }
        isValid = exercisesExist && allFieldsFilled
    }
    
    // 운동 삭제
    func removeExercise(at index: Int) {
        guard index < selectedExercises.count else { return }
        
        selectedExercises.remove(at: index)
        validateExercises()
    }
    
    // 스케줄 저장
    func saveSchedule(for date: Date) {
        realmManager.saveSchedule(selectedExercises: selectedExercises, for: date)
    }
}

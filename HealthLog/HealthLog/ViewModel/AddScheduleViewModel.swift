//
//  AddScheduleViewModel.swift
//  HealthLog
//
//  Created by seokyung on 8/20/24.
//

import Combine
import Foundation

struct ScheduleStruct {
    let date: Date
    var exercises: [ScheduleExerciseStruct]
    var highlightedBodyParts: [HighlightedBodyPartStruct]
}

struct ScheduleExerciseStruct {
    let exerciseName: String
    let order: Int
    var isCompleted: Bool
    var sets: [ScheduleExerciseSetStruct]
}

struct ScheduleExerciseSetStruct {
    let order: Int
    let weight: Int
    let reps: Int
    var isCompleted: Bool
}

struct HighlightedBodyPartStruct {
    let bodyPartName: String
    let step: Int
}

class AddScheduleViewModel {
    @Published var selectedExercises: [ScheduleExerciseStruct] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func addExercise(_ exerciseName: String) {
        let scheduleExercise = ScheduleExerciseStruct(exerciseName: exerciseName, order: selectedExercises.count, isCompleted: false, sets: [])
        selectedExercises.append(scheduleExercise)
    }
    
    // 세트, 무게, 횟수 설정 후 ScheduleExerciseSetStruct을 업데이트
    func updateExerciseSet(for index: Int, sets: [ScheduleExerciseSetStruct]) {
        guard index < selectedExercises.count else { return }
        print("뷰모델Updating exercise at index \(index) with \(sets.count) sets")
        selectedExercises[index].sets = sets
    }
    
    func removeExercise(at index: Int) {
        guard index < selectedExercises.count else { return }
        selectedExercises.remove(at: index)
    }
    
    func saveSchedule(for date: Date) {
        let schedule = ScheduleStruct(date: date, exercises: selectedExercises, highlightedBodyParts: [])
        print(schedule) // realm에 저장하도록 수정필요
    }
}

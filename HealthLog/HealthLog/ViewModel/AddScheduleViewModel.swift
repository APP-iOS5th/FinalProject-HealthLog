//
//  AddScheduleViewModel.swift
//  HealthLog
//
//  Created by seokyung on 8/20/24.
//

import Combine
import Foundation
import RealmSwift

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
    var setCount: Int = 4
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
        let scheduleExercise = ScheduleExerciseStruct(exerciseName: exerciseName, order: selectedExercises.count, isCompleted: false, sets: [], setCount: 4)
        selectedExercises.append(scheduleExercise)
    }
    
    func updateExerciseSetCount(for index: Int, setCount: Int) {
        guard index < selectedExercises.count else { return }
        selectedExercises[index].setCount = setCount
    }
    
    // 세트, 무게, 횟수 설정 후 ScheduleExerciseSetStruct을 업데이트
    func updateExerciseSet(for index: Int, sets: [ScheduleExerciseSetStruct]) {
        guard index < selectedExercises.count else { return }
        selectedExercises[index].sets = sets
    }
    
    func removeExercise(at index: Int) {
        guard index < selectedExercises.count else { return }
        selectedExercises.remove(at: index)
    }
    
    func saveSchedule(for date: Date) {
        let schedule = ScheduleStruct(date: date, exercises: selectedExercises, highlightedBodyParts: [])
        //print(schedule) // 생성된 데이터 확인
    }
    
//    // 아직 만드는 중,,
//    func saveSchedulerealm(for date: Date) {
//    // 해당날짜에 스케줄 있는 경우 처리 필요
//        let scheduleExercises = selectedExercises.map { exerciseStruct -> ScheduleExercise in
//            let exercise = RealmManager.shared.realm.objects(Exercise.self).filter("name == %@", exerciseStruct.exerciseName).first!
//            let sets = exerciseStruct.sets.map { setStruct in
//                ScheduleExerciseSet(order: setStruct.order, weight: setStruct.weight, reps: setStruct.reps, isCompleted: setStruct.isCompleted)
//            }
//            return ScheduleExercise(exercise: exercise, order: exerciseStruct.order, isCompleted: exerciseStruct.isCompleted, sets: sets)
//        }
//        
//        let highlightedBodyParts = selectedExercises.flatMap { exerciseStruct -> [HighlightedBodyPart] in
//            let exercise = RealmManager.shared.realm.objects(Exercise.self).filter("name == %@", exerciseStruct.exerciseName).first!
//            return exercise.bodyParts.map { bodyPart in
//                HighlightedBodyPart(bodyPart: bodyPart, step: 1)  // ...
//            }
//        }
//        
//        let schedule = Schedule(date: date, exercises: scheduleExercises, highlightedBodyParts: highlightedBodyParts)
//        
//        do {
//            let realm = RealmManager.shared.realm
//            try realm.write {
//                realm.add(schedule)
//            }
//            print("Schedule saved successfully")
//        } catch {
//            print("Error saving schedule: \(error)")
//        }
//    }
}

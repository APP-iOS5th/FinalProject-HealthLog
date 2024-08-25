//
//  TestAddScheduleViewModel.swift
//  HealthLog
//
//  Created by user on 8/25/24.
//


import Combine
import Foundation
import RealmSwift

class TestAddScheduleViewModel {
    
    // MARK: 영우 - Realm 모델 사용
    //  아마 이게 Struct보다 DB에 넣기 좋음
    @Published var selectedExercises: [ScheduleExercise] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    // MARK: 영우 - Realm 모델 사용으로 인한 변경
    // Exercise 타입으로 변경
    // sets 4개 생성 코드 추가
    func addExercise(_ exercise: Exercise) {
        let setCount = 4
        let sets = (1...setCount).map { order in
            ScheduleExerciseSet(
                order: order, weight: 0, reps: 0, isCompleted: false)
        }

        let scheduleExercise = ScheduleExercise(exercise: exercise, order: selectedExercises.count, isCompleted: false, sets: sets)
        selectedExercises.append(scheduleExercise)
    }
    
    // MARK: 영우 - Realm 모델 사용으로 인한 변경
    // set를 1개 추가 삭제
    func updateExerciseSetCount(for index: Int, setCount: Int) {
//        guard index < selectedExercises.count else { return }
        print("setCount-\(setCount)--count-\(selectedExercises[index].sets.count)")
        if(setCount > selectedExercises[index].sets.count) {
            print("--append--)")
            let set = ScheduleExerciseSet(
                order: setCount, weight: 0, reps: 0, isCompleted: false)
            selectedExercises[index].sets.append(set)
        } else if (setCount < selectedExercises[index].sets.count) {
            print("--delete--")
            selectedExercises[index].sets.removeLast()
        }
//        var test: ScheduleExercise! = selectedExercises[index]
//        print(test)
    }
    
    // MARK: 영우 - Realm 모델 사용으로 인한 변경
    // 세트, 무게, 횟수 설정 후 ScheduleExerciseSet을 업데이트
    func updateExerciseSet(for index: Int, sets: [ScheduleExerciseSet]) {
        guard index < selectedExercises.count else { return }
//        selectedExercises[index].sets = sets
    }
    
    // MARK: 영우 - Realm 모델 사용으로 인한 변경
    func removeExercise(at index: Int) {
        guard index < selectedExercises.count else { return }
        selectedExercises.remove(at: index)
    }
    
    func saveSchedule(for date: Date) {
        print(selectedExercises)
        let schedule = Schedule(date: date, exercises: selectedExercises)
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

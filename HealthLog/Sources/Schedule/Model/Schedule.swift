//
//  Schedule.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import Foundation
import RealmSwift

// 스케줄을 나타내는 모델 정의
class Schedule: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var date: Date // 날짜
    @Persisted var exercises: List<ScheduleExercise> // 운동 리스트 1:M
//    @Persisted var highlightedBodyParts: List<HighlightedBodyPart> // 부위 색칠 1:M - 부위,단계
    
    convenience init(date: Date, exercises: [ScheduleExercise]/*, highlightedBodyParts: [HighlightedBodyPart]*/) {
        self.init()
        self.date = date
        self.exercises.append(objectsIn: exercises)
//        self.highlightedBodyParts.append(objectsIn: highlightedBodyParts)
    }
}

class ScheduleExercise: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var exercise: Exercise? // 운동 - id, 이름, 부위
    @Persisted var order: Int // 운동 순서
    @Persisted var isCompleted: Bool // 운동 완료 여부
    @Persisted var sets: List<ScheduleExerciseSet> // 운동 세트
    
    convenience init(exercise: Exercise, order: Int, isCompleted: Bool, sets: [ScheduleExerciseSet]) {
        self.init()
        self.exercise = exercise
        self.order = order
        self.isCompleted = isCompleted
        self.sets.append(objectsIn: sets)
    }
}

class ScheduleExerciseSet: EmbeddedObject {
//    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var order: Int // 세트 순서
    @Persisted var weight: Int // 무게
    @Persisted var reps: Int // 횟수
    @Persisted var isCompleted: Bool // 세트 완료 여부
    
    convenience init(order: Int, weight: Int, reps: Int, isCompleted: Bool) {
        self.init()
        self.order = order
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
    }
}

//class HighlightedBodyPart : Object {
//    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
//    @Persisted var bodyPart: BodyPart? // 부위 1:1
//    @Persisted var step: Int // 단계
//    
//    convenience init(bodyPart: BodyPart, step: Int) {
//        self.init()
//        self.bodyPart = bodyPart
//        self.step = step
//        
//        // step 대신 total sets 는 어떤지 ex) 체크 할때마다 +1
//        // 또는 그냥 아에 HighlightedBodyPart 부분을 삭제하고 vm에서 계산해서 사용하는게 나을 지도
//    }
//}

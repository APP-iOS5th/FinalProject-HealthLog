//
//  Report.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import Foundation
import RealmSwift

class Report: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var date: Date // 날짜 (년, 월)
    @Persisted var bodyParts: List<ReportBodyPart> // 부위별 1:M
    
    convenience init(date: Date, bodyParts: [ReportBodyPart]) {
        self.init()
        self.date = date
        self.bodyParts.append(objectsIn: bodyParts)
    }
}

class ReportBodyPart: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var bodyPart: BodyPart? // 부위 1:1 - 이름
    @Persisted var exercises: List<ReportBodyPartExercise> // 운동 1:M
    
    convenience init(bodyPart: BodyPart, exercises: [ReportBodyPartExercise]) {
        self.init()
        self.bodyPart = bodyPart
        self.exercises.append(objectsIn: exercises)
    }
}

class ReportBodyPartExercise: Object {
    @Persisted var exercise: Exercise? // 운동 1:M - 이름
    @Persisted var setsCount: Int // 세트 수
    @Persisted var completedReps: Int // 완료한 횟수
    @Persisted var minWeight: Int // 최소 무게
    @Persisted var maxWeight: Int // 최대 무게
    
    convenience init(exercise: Exercise, setsCount: Int, completedReps: Int, minWeight: Int, maxWeight: Int) {
        self.init()
        self.exercise = exercise
        self.setsCount = setsCount
        self.completedReps = completedReps
        self.minWeight = minWeight
        self.maxWeight = maxWeight
    }
}



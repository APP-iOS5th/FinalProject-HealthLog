//
//  Routine.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import RealmSwift

class Routine: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var name: String // 루틴 이름
    @Persisted var exercises: List<RoutineExercise> // 운동 1:M
    @Persisted var exerciseVolume: Int // 볼륨량
    
    convenience init(name: String, exercises: [RoutineExercise], exerciseVolume: Int) {
        self.init()
        self.name = name
        self.exercises.append(objectsIn: exercises)
        self.exerciseVolume = exerciseVolume
    }
}

class RoutineExercise: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var exercise: Exercise // 운동 리스트 1:1
    @Persisted var sets: List<RoutineExerciseSet> // 세트 1:M
    
    convenience init(exercise: Exercise, sets: [RoutineExerciseSet]) {
        self.init()
        self.exercise = exercise
        self.sets.append(objectsIn: sets)
    }
}

class RoutineExerciseSet: EmbeddedObject {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var order: Int // 순서
    @Persisted var weight: Int // 무게
    @Persisted var reps: Int // 횟수
    
    convenience init(order: Int, weight: Int, reps: Int) {
        self.init()
        self.order = order
        self.weight = weight
        self.reps = reps
    }
}




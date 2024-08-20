//
//  RealmManager.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    private(set) var realm: Realm
//    var bodyParts: Results<BodyPart>
    
    private init() {
        if let realmFileURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("open \(realmFileURL)")
        }
        
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
        
//        bodyParts = realm.objects(BodyPart.self)
//        initializeBodyParts()
        initializeRealmExercise()
        initializeRealmRoutine()
        initializeRealmSchedule()
    }
}

extension RealmManager {
//    func bodyPartSearch (_ bodyPartTypes: [BodyPart]) -> [BodyPart] {
//        let filteredBodyParts = bodyParts.filter { bodyPart in
//            bodyPartTypes.contains(bodyPart.name)
//        }
//        return Array(filteredBodyParts)
//    }
}

// MARK: - InitializeRealmData
extension RealmManager {
    
    func initializeRealmExercise() {
        if realm.objects(Exercise.self).isEmpty {
            let sampleExercises = [
                Exercise(name: "스쿼트", bodyParts: [.quadriceps, .glutes], descriptionText: "다리 운동", image: nil, totalReps: 75, recentWeight: 80, maxWeight: 120, isCustom: false),
                Exercise(name: "Shoulder Press", bodyParts: [.shoulders], descriptionText: "Shoulder exercise Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test TestTest TestTestTest Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test ", image: nil, totalReps: 60, recentWeight: 40, maxWeight: 60, isCustom: false),
                Exercise(name: "Bicep Curl", bodyParts: [.biceps], descriptionText: "Arm exercise", image: nil, totalReps: 90, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Tricep Dip", bodyParts: [.triceps], descriptionText: "Arm exercise", image: nil, totalReps: 80, recentWeight: 25, maxWeight: 40, isCustom: false),
                Exercise(name: "Lateral Raise", bodyParts: [.shoulders], descriptionText: "Shoulder isolation exercise", image: nil, totalReps: 70, recentWeight: 10, maxWeight: 15, isCustom: false),
                Exercise(name: "레그 프레스", bodyParts: [.quadriceps, .glutes], descriptionText: "다리 운동2", image: nil, totalReps: 50, recentWeight: 180, maxWeight: 200, isCustom: false),
                Exercise(name: "Plank", bodyParts: [.abs], descriptionText: "Core exercise", image: nil, totalReps: 5, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Leg Curl", bodyParts: [.hamstrings], descriptionText: "Hamstring exercise", image: nil, totalReps: 60, recentWeight: 50, maxWeight: 60, isCustom: false),
                Exercise(name: "Calf Raise", bodyParts: [.calves], descriptionText: "Calf exercise", image: nil, totalReps: 100, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Pull-up", bodyParts: [.back, .biceps], descriptionText: "Back and biceps exercise", image: nil, totalReps: 40, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Chest Fly", bodyParts: [.chest], descriptionText: "Chest isolation exercise", image: nil, totalReps: 70, recentWeight: 25, maxWeight: 40, isCustom: false),
                Exercise(name: "Russian Twist", bodyParts: [.abs], descriptionText: "Core rotational exercise", image: nil, totalReps: 50, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Glute Bridge", bodyParts: [.glutes], descriptionText: "Glute exercise", image: nil, totalReps: 30, recentWeight: 40, maxWeight: 60, isCustom: false),
                Exercise(name: "Lunges", bodyParts: [.quadriceps, .glutes], descriptionText: "Leg exercise", image: nil, totalReps: 60, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Hammer Curl", bodyParts: [.biceps], descriptionText: "Bicep exercise", image: nil, totalReps: 80, recentWeight: 15, maxWeight: 25, isCustom: false),
                Exercise(name: "Tricep Kickback", bodyParts: [.triceps], descriptionText: "Tricep isolation exercise", image: nil, totalReps: 75, recentWeight: 10, maxWeight: 15, isCustom: false),
                Exercise(name: "Side Plank", bodyParts: [.abs], descriptionText: "Core stabilization exercise", image: nil, totalReps: 5, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Hip Thrust", bodyParts: [.glutes], descriptionText: "Glute exercise", image: nil, totalReps: 50, recentWeight: 60, maxWeight: 80, isCustom: false)
            ]
            
            try! realm.write {
                realm.add(sampleExercises)
            }
            
            print("기본 Exercise 더미데이터 넣기")
        } else {
            print("기본 Exercise 데이터가 이미 존재합니다.")
        }
    }
    
    
    func initializeRealmRoutine() {
        if realm.objects(Routine.self).isEmpty {
            
            // 1. 기존 Exercise 객체 조회
            let exercises = realm.objects(Exercise.self)
            
            // Exercise 데이터가 존재하지 않는 경우 처리
            guard !exercises.isEmpty else {
                print("Routine - 기존 Exercise 데이터가 없습니다.")
                return
            }
            
            // 2. RoutineExercise 및 RoutineExerciseSet 생성
            let routineExercises1 = [
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    sets: [
                        RoutineExerciseSet(order: 2, weight: 90, reps: 12)
                    ]
                ),
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 150, reps: 10),
                        RoutineExerciseSet(order: 2, weight: 160, reps: 8)
                    ]
                )
            ]
            
            let routineExercises2 = [
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 85, reps: 15),
                        RoutineExerciseSet(order: 2, weight: 95, reps: 12)
                    ]
                ),
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 160, reps: 10),
                        RoutineExerciseSet(order: 2, weight: 170, reps: 8)
                    ]
                )
            ]
            
            let routineExercises3 = [
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 90, reps: 12),
                        RoutineExerciseSet(order: 2, weight: 100, reps: 10)
                    ]
                ),
                RoutineExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    sets: [
                        RoutineExerciseSet(order: 1, weight: 160, reps: 12),
                        RoutineExerciseSet(order: 1, weight: 170, reps: 10),
                        RoutineExerciseSet(order: 2, weight: 180, reps: 8)
                    ]
                )
            ]
            
            let routine1 = Routine(name: "하체 루틴 1", exercises: routineExercises1, exerciseVolume: 2)
            let routine2 = Routine(name: "하체 루틴 2", exercises: routineExercises2, exerciseVolume: 2)
            let routine3 = Routine(name: "하체 루틴 3", exercises: routineExercises3, exerciseVolume: 2)
            
            // 3. Realm에 샘플 데이터 추가
            try! realm.write {
                realm.add([routine1, routine2, routine3])
            }

            
            print("기본 Routine 더미데이터 넣기")
        } else {
            print("기본 Routine 데이터가 이미 존재합니다.")
        }
    }
    
    func initializeRealmSchedule() {
        if realm.objects(Schedule.self).isEmpty {
            
            // 1. 기존 Exercise 객체 조회
            let exercises = realm.objects(Exercise.self)
            
            // Exercise 데이터가 존재하지 않는 경우 처리
            guard !exercises.isEmpty else {
                print("Schedule - 기존 Exercise 데이터가 없습니다.")
                return
            }
            
            // 2. ScheduleExercise 및 HighlightedBodyPart 생성
            let sampleExercises1 = [
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    order: 1,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 80, reps: 15, isCompleted: false)
                    ]
                ),
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    order: 2,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 150, reps: 6, isCompleted: false),
                        ScheduleExerciseSet(order: 2, weight: 160, reps: 8, isCompleted: false)
                    ]
                )
            ]
            let sampleExercises2 = [
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    order: 1,
                    isCompleted: true,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 90, reps: 15, isCompleted: false)
                    ]
                ),
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    order: 2,
                    isCompleted: true,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 170, reps: 12, isCompleted: false)
                    ]
                )
            ]
            let sampleExercises3 = [
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "스쿼트" })!,
                    order: 1,
                    isCompleted: false,
                    sets: [
                        ScheduleExerciseSet(order: 1, weight: 80, reps: 15, isCompleted: false),
                        ScheduleExerciseSet(order: 2, weight: 90, reps: 10, isCompleted: false),
                    ]
                ),
                ScheduleExercise(
                    exercise: exercises.first(where: { $0.name == "레그 프레스" })!,
                    order: 2,
                    isCompleted: false,
                    sets: [ScheduleExerciseSet(order: 1, weight: 180, reps: 12, isCompleted: false)]
                )
            ]
            
            let highlightedBodyParts1 = [
                HighlightedBodyPart(bodyPart: .quadriceps, step: 1),
                HighlightedBodyPart(bodyPart: .glutes, step: 1)
            ]
            let highlightedBodyParts2 = [
                HighlightedBodyPart(bodyPart: .quadriceps, step: 1),
                HighlightedBodyPart(bodyPart: .glutes, step: 1)
            ]
            let highlightedBodyParts3 = [
                HighlightedBodyPart(bodyPart: .quadriceps, step: 1),
                HighlightedBodyPart(bodyPart: .glutes, step: 1)
            ]
            
            let sampleSchedule = [
                Schedule(date: getDate(year: 2024, month: 7, day: 15), exercises: sampleExercises1, highlightedBodyParts: highlightedBodyParts1),
                Schedule(date: getDate(year: 2024, month: 8, day: 15), exercises: sampleExercises2, highlightedBodyParts: highlightedBodyParts2),
                Schedule(date: getDate(year: 2024, month: 8, day: 21), exercises: sampleExercises3, highlightedBodyParts: highlightedBodyParts3),
            ]
            
            // 3. Realm에 샘플 데이터 추가
            try! realm.write {
                realm.add(sampleSchedule)
            }
            
            print("기본 Schedule 더미데이터 넣기")
        } else {
            print("기본 Schedule 데이터가 이미 존재합니다.")
        }
    }
    
    
    // MARK: - 초기화에 필요한 함수들
    private func getDate(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        let calendar = Calendar.current
        return calendar.date(from: dateComponents) ?? Date()
    }
    
}

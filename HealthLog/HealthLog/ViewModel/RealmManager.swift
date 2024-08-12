//
//  RealmManager.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private(set) var realm: Realm
    var bodyParts: Results<BodyPart>
    
    private init() {
        do {
            realm = try Realm()
            print("open \(realm.configuration.fileURL!)")
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
        
        bodyParts = realm.objects(BodyPart.self)
        initializeBodyParts()
        initializeRealmExercise()
    }
}

extension RealmManager {
    func bodyPartSearch (_ bodyPartTypes: [BodyPartType]) -> [BodyPart] {
        let filteredBodyParts = bodyParts.filter { bodyPart in
            bodyPartTypes.contains(bodyPart.name)
        }
        return Array(filteredBodyParts)
    }
}

extension RealmManager {
    func initializeBodyParts() {
        if realm.objects(BodyPart.self).isEmpty {
            let bodyParts = BodyPartType.allCases.map { BodyPart(name: $0) }
            
            try! realm.write {
                realm.add(bodyParts)
            }
            print("기본 BodyPart 더미데이터 넣기")
        } else {
            print("기본 BodyPart 데이터가 이미 존재합니다.")
        }
    }
    
    func initializeRealmExercise() {
        if realm.objects(Exercise.self).isEmpty {
            let sampleExercises = [
                Exercise(name: "Squat", bodyParts: bodyPartSearch([.quadriceps, .glutes]), descriptionText: "Leg exercise", image: nil, totalReps: 75, recentWeight: 80, maxWeight: 120, isCustom: false),
                Exercise(name: "Shoulder Press", bodyParts: bodyPartSearch([.shoulders]), descriptionText: "Shoulder exercise", image: nil, totalReps: 60, recentWeight: 40, maxWeight: 60, isCustom: false),
                Exercise(name: "Bicep Curl", bodyParts: bodyPartSearch([.biceps]), descriptionText: "Arm exercise", image: nil, totalReps: 90, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Tricep Dip", bodyParts: bodyPartSearch([.triceps]), descriptionText: "Arm exercise", image: nil, totalReps: 80, recentWeight: 25, maxWeight: 40, isCustom: false),
                Exercise(name: "Lateral Raise", bodyParts: bodyPartSearch([.shoulders]), descriptionText: "Shoulder isolation exercise", image: nil, totalReps: 70, recentWeight: 10, maxWeight: 15, isCustom: false),
                Exercise(name: "Leg Press", bodyParts: bodyPartSearch([.quadriceps, .glutes]), descriptionText: "Leg exercise", image: nil, totalReps: 50, recentWeight: 180, maxWeight: 200, isCustom: false),
                Exercise(name: "Plank", bodyParts: bodyPartSearch([.abs]), descriptionText: "Core exercise", image: nil, totalReps: 5, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Leg Curl", bodyParts: bodyPartSearch([.hamstrings]), descriptionText: "Hamstring exercise", image: nil, totalReps: 60, recentWeight: 50, maxWeight: 60, isCustom: false),
                Exercise(name: "Calf Raise", bodyParts: bodyPartSearch([.calves]), descriptionText: "Calf exercise", image: nil, totalReps: 100, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Pull-up", bodyParts: bodyPartSearch([.back, .biceps]), descriptionText: "Back and biceps exercise", image: nil, totalReps: 40, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Chest Fly", bodyParts: bodyPartSearch([.chest]), descriptionText: "Chest isolation exercise", image: nil, totalReps: 70, recentWeight: 25, maxWeight: 40, isCustom: false),
                Exercise(name: "Russian Twist", bodyParts: bodyPartSearch([.abs]), descriptionText: "Core rotational exercise", image: nil, totalReps: 50, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Glute Bridge", bodyParts: bodyPartSearch([.glutes]), descriptionText: "Glute exercise", image: nil, totalReps: 30, recentWeight: 40, maxWeight: 60, isCustom: false),
                Exercise(name: "Lunges", bodyParts: bodyPartSearch([.quadriceps, .glutes]), descriptionText: "Leg exercise", image: nil, totalReps: 60, recentWeight: 20, maxWeight: 30, isCustom: false),
                Exercise(name: "Hammer Curl", bodyParts: bodyPartSearch([.biceps]), descriptionText: "Bicep exercise", image: nil, totalReps: 80, recentWeight: 15, maxWeight: 25, isCustom: false),
                Exercise(name: "Tricep Kickback", bodyParts: bodyPartSearch([.triceps]), descriptionText: "Tricep isolation exercise", image: nil, totalReps: 75, recentWeight: 10, maxWeight: 15, isCustom: false),
                Exercise(name: "Side Plank", bodyParts: bodyPartSearch([.abs]), descriptionText: "Core stabilization exercise", image: nil, totalReps: 5, recentWeight: 0, maxWeight: 0, isCustom: false),
                Exercise(name: "Hip Thrust", bodyParts: bodyPartSearch([.glutes]), descriptionText: "Glute exercise", image: nil, totalReps: 50, recentWeight: 60, maxWeight: 80, isCustom: false)
            ]
            
            try! realm.write {
                realm.add(sampleExercises)
            }
            
            print("기본 Exercise 더미데이터 넣기")
        } else {
            print("기본 Exercise 데이터가 이미 존재합니다.")
        }
    }
    
}

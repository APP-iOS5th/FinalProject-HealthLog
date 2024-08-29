//
//  entryExercise.swift
//  HealthLog
//
//  Created by user on 8/28/24.
//

import UIKit
import RealmSwift

// MARK: -
// 입력용 Exercise
class EntryExercise: ObservableObject {
    @Published var name: String = ""
    @Published var bodyParts: [BodyPart] = []
    var recentWeight: Int = 0
    var maxWeight: Int = 0
    var description: String = ""
    @Published var images: [Data?] = [Data(), Data()]
    
    @Published var isValidatedRequiredFields: Bool = false
    @Published var hasDuplicateName: Bool = false
    @Published var isNameEmpty: Bool = false
    @Published var isBodyPartsEmpty: Bool = false
    
    func initInputExercise() {
        name = ""
        bodyParts = []
        recentWeight = 0
        maxWeight = 0
        description = ""
        
        isValidatedRequiredFields = false
        hasDuplicateName = false
        isNameEmpty = true
        isBodyPartsEmpty = true
    }
    
    func addRealmExerciseObject() -> Exercise {
        let dbImages: [ExerciseImage] = images.map { image in
            ExerciseImage(image: image, url: nil, urlAccessCount: 0)
        }
        
        return Exercise(
            name: name,
            bodyParts: bodyParts,
            descriptionText: description,
            images: dbImages,
            totalReps: 0,
            recentWeight: recentWeight,
            maxWeight: maxWeight,
            isCustom: true
        )
    }
    
    func updateRealmExerciseObject(id: ObjectId) -> Exercise {
        let dbImages: [ExerciseImage] = images.map { image in
            ExerciseImage(image: image, url: nil, urlAccessCount: 0)
        }
        
        return Exercise(
            name: name,
            bodyParts: bodyParts,
            descriptionText: description,
            images: dbImages,
            totalReps: 0,
            recentWeight: recentWeight,
            maxWeight: maxWeight,
            isCustom: true
        )
    }
}

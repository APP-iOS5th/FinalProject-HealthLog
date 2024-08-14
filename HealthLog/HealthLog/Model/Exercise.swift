//
//  Exercise.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import RealmSwift
import Foundation

// 운동 리스트를 나타내는 모델 정의
class Exercise: Object {
    @Persisted(primaryKey: true) var id: ObjectId // 운동의 고유 ID
    @Persisted var name: String // 운동 이름
    @Persisted var bodyParts: List<BodyPart>  // 운동 부위 - 부위 이름
    @Persisted var descriptionText: String = "" // 운동 설명 (옵션)
    @Persisted var image: Data? = nil // 운동 이미지 (옵션)
    @Persisted var totalReps: Int = 0 // 총 운동 횟수 (옵션)
    @Persisted var recentWeight: Int = 0 // 최근 무게 (옵션)
    @Persisted var maxWeight: Int = 0 // 최대 무게 (옵션)
    @Persisted var isCustom: Bool = false // 운동 커스텀 여부
    
    // 생성자
    convenience init(name: String, bodyParts: [BodyPart], descriptionText: String, image: Data?, totalReps: Int, recentWeight: Int, maxWeight: Int, isCustom: Bool) {
        self.init()
        self.name = name
        self.bodyParts.append(objectsIn: bodyParts)
        self.descriptionText = descriptionText
        self.image = image
        self.totalReps = totalReps
        self.recentWeight = recentWeight
        self.maxWeight = maxWeight
        self.isCustom = isCustom
    }
}

//
//  InBody.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import Foundation
import RealmSwift

class InBody: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId // 고유 ID
    @Persisted var date: Date = Date() // 날짜
    @Persisted var weight: Float // 몸무게
    @Persisted var bodyFat: Float // 체지방
    @Persisted var muscleMass: Float // 골격근량
    
    convenience init(date: Date, weight: Float, bodyFat: Float, muscleMass: Float) { // 샘플 데이터를 위해 잠시 초기화 값 넣을게요. _ 허원열
        self.init()
        self.date = date
        self.weight = weight
        self.bodyFat = bodyFat
        self.muscleMass = muscleMass
    }
}

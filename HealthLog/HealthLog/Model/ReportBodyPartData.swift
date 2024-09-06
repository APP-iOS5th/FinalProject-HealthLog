//
//  Report.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import Foundation

// 이 파일은 realm 모델이 아님
struct ReportBodyPartData {
    let bodyPart: String
    var totalSets: Int
    var exercises: [ExerciseSets]
    var isStackViewVisible: Bool = false // 기본값: 안보이기
}

struct ExerciseSets {
    let name: String
    var setsCount: Int
    var daysCount: Int
    var minWeight: Int
    var maxWeight: Int
}




//
//  BodyPart.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import RealmSwift

enum BodyPart: String, PersistableEnum {
    case chest = "가슴"
    case back = "등"
    case shoulders = "어깨"
    case triceps = "삼두"
    case biceps = "이두"
    case abs = "복근"
    case quadriceps = "전면 허벅지"
    case hamstrings = "후면 허벅지"
    case glutes = "엉덩이"
    case adductors = "내전근"
    case abductors = "외전근"
    case calves = "종아리"
    case other = "기타"
}

enum BodyPartOption {
    case all
    case bodyPart(BodyPart)
    
    var name: String {
        switch self {
            case .all: return "전체"
            case .bodyPart(let bodyPart): return bodyPart.rawValue
        }
    }
    
    static var allName: [String] {
        return [BodyPartOption.all.name] + BodyPart.allCases.map { $0.rawValue }
    }
}

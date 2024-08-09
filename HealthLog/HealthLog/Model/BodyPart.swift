//
//  BodyPart.swift
//  HealthLog
//
//  Created by user on 8/9/24.
//

import RealmSwift

enum BodyPartType: String, PersistableEnum {
    case arm = "팔"
    case chatting
}

class BodyPart: Object {
    @Persisted(primaryKey: true) var name: BodyPartType = .arm
    
    convenience init(name: BodyPartType) {
        self.init()
        self.name = name
    }
}

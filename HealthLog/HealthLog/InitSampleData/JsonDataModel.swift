//
//  JsonDataModel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Foundation

// JSON 파일을 읽어오는 함수
func loadJSON<T: Decodable>(filename: String, as type: T.Type = T.self) -> T? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
        print("JSON file not found.")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("Failed to load JSON file: \(error)")
        return nil
    }
}

struct BodyPartJSON: Codable {
    let name: String
}

struct ExerciseJSON: Codable {
    let name: String
    let bodyParts: [BodyPartJSON]
    let descriptionText: String?
    let image: String? // image는 Base64 인코딩된 문자열로 가정
    let totalReps: Int
    let recentWeight: Int
    let maxWeight: Int
    let isCustom: Bool
}

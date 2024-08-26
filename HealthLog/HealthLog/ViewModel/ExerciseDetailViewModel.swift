//
//  ExerciseDetailViewModel.swift
//  HealthLog
//
//  Created by user on 8/22/24.
//

import Foundation
import RealmSwift
import Combine

class ExerciseDetailViewModel: ObservableObject {
    let realm = RealmManager.shared.realm // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    @Published var exercise: Exercise
    
    // MARK: - Init
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func realmExerciseIsDeleted() {
        guard let realm = realm else {return} // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        realm.writeAsync() {
            self.exercise.isDeleted = true
        }
    }
}

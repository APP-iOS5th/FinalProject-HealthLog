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

    // MARK: - Properties
    
    private let realm = RealmManager.shared.realm
    private var cancellables = Set<AnyCancellable>()
    var viewModel: ExerciseViewModel
    
    @Published var exercise: Exercise
    
    // MARK: - Init
    
    init(exercise: Exercise, viewModel: ExerciseViewModel) {
        self.exercise = exercise
        self.viewModel = viewModel
    }
    
    func realmExerciseIsDeleted() {
        guard let realm = realm else { return } // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        realm.writeAsync() {
            self.exercise.isDeleted = true
        }
    }
}

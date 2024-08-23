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
    
    private var cancellables = Set<AnyCancellable>()
    @Published var exercise: Exercise
    
    // MARK: - Init
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func realmDeleteExercise() {
        RealmManager.shared.realm.writeAsync() {
            RealmManager.shared.realm.delete(self.exercise)
        }
    }
}

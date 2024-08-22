//
//  ExerciseDetailViewModel.swift
//  HealthLog
//
//  Created by user on 8/22/24.
//

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
        let realm = RealmManager.shared.realm
        try! realm.write {
            realm.delete(exercise)
        }
    }
}

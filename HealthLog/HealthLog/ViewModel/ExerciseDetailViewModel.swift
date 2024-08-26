//
//  ExerciseDetailViewModel.swift
//  HealthLog
//
//  Created by user on 8/22/24.
//

import Foundation
import RealmSwift
import Combine
import UIKit

class ExerciseDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private var exerciseNotificationToken: NotificationToken?
    private let realm = RealmManager.shared.realm
    private var cancellables = Set<AnyCancellable>()
    var viewModel: ExerciseViewModel
    
    @Published var exercise: Exercise
    
    // MARK: - Init
    
    init(exercise: Exercise, viewModel: ExerciseViewModel) {
        self.exercise = exercise
        self.viewModel = viewModel
        
        observeRealmData(specificId: exercise.id)
    }
    
    // MARK: 1
    // Realm 데이터 -> Combine Published 변수
    private func observeRealmData(specificId: ObjectId) {
        guard let realm = realm else {return}
        
        guard let results = realm.object(
            ofType: Exercise.self, forPrimaryKey: specificId) 
        else {
            print("realm - not found target exercise")
            return
        }
        
        exerciseNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .change(let data, _):
                    print("results.observe - update")
                    self?.exercise = data as! Exercise
                case .deleted:
                    print("results.observe - deleted")
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    
}

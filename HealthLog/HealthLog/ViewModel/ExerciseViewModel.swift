//
//  ViewModel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Combine
import RealmSwift
import Foundation

class ExerciseViewModel: ObservableObject {
    private var realm: Realm
    private var exercisesNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var exercises: [Exercise] = []
    @Published var filteredExercises: [Exercise] = []
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        exercisesSubject()
    }
    
    deinit {
        exercisesNotificationToken?.invalidate()
    }
    
    private func observeRealmData() {
        let results = realm.objects(Exercise.self)
        
        exercisesNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
                    print("results.observe - initial")
                    self?.exercises = Array(collection)
                case .update(let collection, _, _, _):
                    print("results.observe - update")
                    self?.exercises = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
    func exercisesSubject() {
        // realm의 observe가 exercises를 변경시 마다 assign
        $exercises.assign(to: &$filteredExercises)
    }
    
    func filterExercises(by searchText: String) {
        if searchText.isEmpty {
            filteredExercises = exercises
        } else {
            filteredExercises = exercises.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
}

//
//  RoutineViewmodel.swift
//  HealthLog
//
//  Created by 어재선 on 8/20/24.
//

import Foundation
import Combine
import RealmSwift

class RoutineViewModel: ObservableObject{
    
    private var realm: Realm
    
    private var routineNotificationToken: NotificationToken?
    @Published var rutineNameinput: String = "" {
        didSet {
            print("ViewModel / NameInput \(rutineNameinput)")
        }
    }
    @Published var rutines: [Routine] = []
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
    }
    
    lazy var isMatchNameInput: AnyPublisher<Bool,Never> = Publishers
        .CombineLatest($rutineNameinput, $rutines)
        .map( {(rutineNameinput: String, rutines: [Routine]) in
            if rutineNameinput.isEmpty {
                return false
            }
            if (rutines.contains{ $0.name == rutineNameinput}) {
                return false
            } else {
                return true
            }
            
        })
        .print()
        .eraseToAnyPublisher()
    
    
    
    private func observeRealmData() {
        let results = realm.objects(Routine.self)
        
        routineNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
                    print("results.observe - initial")
                    self?.rutines = Array(collection)
                case .update(let collection, _, _, _):
                    print("results.observe - update")
                    self?.rutines = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
}

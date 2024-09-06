//
//  RoutineViewmodel.swift
//  HealthLog
//
//  Created by 어재선 on 8/20/24.
//

import Foundation
import Combine
import RealmSwift

class RoutineViewModel {
    
    
    private var realm: Realm?
    private var realmManger = RealmManager.shared
    
    
    private var routineNotificationToken: NotificationToken?
    
    // RoutineAddName
    private var cancellables = Set<AnyCancellable>()
    
    // Routine 배열
    @Published var routines: [Routine] = []

    // 검색된 값 추가
    @Published var filteredRoutines: [Routine] = []
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
        $routines.assign(to: &$filteredRoutines)
        
        
        
    }
   
    func addScheduleExercise(index: Int) {
        realmManger.updateSchedule(index: index)
    }
    
    func fillteRoutines(by searchText: String) {
        if searchText.isEmpty {
            filteredRoutines = routines
        } else {
            filteredRoutines = routines.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    private func observeRealmData() {
        guard let realm = realm else {return} // realm 에러처리 때문에 이부분 코드 삽입 했습니다 _허원열
        let results = realm.objects(Routine.self)
        
        routineNotificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let collection):
//                print("results.observe - initial")
                self?.routines = Array(collection)
            case .update(let collection, _, _, _):
//                print("results.observe - update")
                self?.routines = Array(collection)
            case .error(let error):
                print("results.observe - error: \(error)")
            }
        }
    }
    
    
}

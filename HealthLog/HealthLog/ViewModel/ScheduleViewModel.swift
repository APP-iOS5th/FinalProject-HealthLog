//
//  ViewModel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import Combine
import RealmSwift
import Foundation

// ViewModel 정의
class ScheduleViewModel: ObservableObject {
    private var realm: Realm?
    private var scheduleNotificationToken: NotificationToken?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var schedules: [Schedule] = []
    
    init() {
        realm = RealmManager.shared.realm
        observeRealmData()
    }
    
    deinit {
        scheduleNotificationToken?.invalidate()
    }
    
    private func observeRealmData() {
        guard let realm = realm else {return} // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        let results = realm.objects(Schedule.self)
        
        scheduleNotificationToken = results.observe { [weak self] changes in
            switch changes {
                case .initial(let collection):
                    print("results.observe - initial")
                    self?.schedules = Array(collection)
                case .update(let collection, _, _, _):
                    print("results.observe - update")
                    self?.schedules = Array(collection)
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
    
}

//
//  InBodyInputViewModel.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/10/24.
//

import Foundation
import RealmSwift

class InBodyInputViewModel {
    
    @Published var inbodyRecords: [InBody] = []
    
    private var realm: Realm?
    
    private var inputNotificationToken: NotificationToken?
    
    
    init() {
        self.realm = RealmManager.shared.getRealm()
        observeRealmData()
        
    }
    
    
    private func observeRealmData() {
        guard let realm = realm else { return }
        
        // MARK: (youngwoo) RealmCombine 03. 데이터 불러옴
        let results = realm.objects(InBody.self)
            .sorted(byKeyPath: "date", ascending: false)
        
        // result에 담은 Realm DB 데이터를 observe로 감시, DB 값 변경시 안에 있는 실행
        inputNotificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let collection):
                self?.inbodyRecords = Array(collection)
                
                //                    print(self?.inbodyRecords ?? [])
            case .update(let collection, _, _, _):
                self?.inbodyRecords = Array(collection)
            case .error(let error):
                print("results.observe - error: \(error)")
            }
        }
    }
    
    
    
}

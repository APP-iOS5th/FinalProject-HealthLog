//
//  ViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 7/25/24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realm 초기화
        let realm = try! Realm()
        print("Realm file path: \(realm.configuration.fileURL!)") // 경로
        
        let exerciseList = realm.objects(Exercise.self).sorted(byKeyPath: "name")
        print(exerciseList)
    }

}


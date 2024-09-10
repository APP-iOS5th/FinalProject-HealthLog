//
//  DataResetViewController.swift
//  HealthLog
//
//  Created by user on 9/10/24.
//

import Foundation
import UIKit

class DataResetViewController : UIViewController {
    private let resetDataButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupResetDataButton()
    }
    
    func setupResetDataButton() {
        resetDataButton.setTitle("Reset", for: .normal)
        resetDataButton.backgroundColor = .colorAccent
        resetDataButton.addTarget(
            self, action: #selector(resetDataButtonTap), for: .touchUpInside)
        view.addSubview(resetDataButton)
        resetDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetDataButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            resetDataButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func resetDataButtonTap() {
        resetData()
    }
    
    func resetData() {
        guard let realm = RealmManager.shared.realm
        else { return }
        
        // 작업중인 Realm 비동기 Task를 취소
        print("initializeTask - \(RealmManager.shared.initializeTask)")
        RealmManager.shared.cancelInitializeTask()
        print("initializeTask cancel after - \(RealmManager.shared.initializeTask)")
        if let id = RealmManager.shared.asyncTransactionId {
            print("id = \(id)")
            try! realm.cancelAsyncWrite(id)
        }
        
        // 루프처리로 계속 돌수도 있어서 일단 놔둘게요.
        
        
        // 그냥 플래그 써서 처리 못하게 막을까요..
        // 네.
        
        // 네. realm 제공입니다
        
        do {
            try realm.write {
                realm.deleteAll() // relam 기본
            }
        } catch {
            print("realm write 오류")
        }
        
        // 이미지 다운로드 처리 끝나기 전에 이 리셋 한번 더 클릭 하게되면 충돌나서 해결중입니다.
        // 네 이미지 다운로드 처리중이라.. 완료된 후에 하면 괜찮습니다.
    
        
        // 네. 작업 끝나고하면 괜찮더라고요.
        
        
        
        
        RealmManager.shared.initializeRealmExercise() // 운동데이터 DB 입력
        RealmManager.shared.initializeTask = Task { await RealmManager.shared.initializeRealmExerciseImages() } // 운동데이터 이미지 다운 및 DB 입력
    }
    
    
}

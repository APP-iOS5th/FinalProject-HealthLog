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
    private let cancelTaskButton = UIButton(type: .system)
    private let deleteAllDataButton = UIButton(type: .system)
    private let addAllDataButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupResetDataButton()
        
        // 테스트를 위한 처리 분리
        setupCancelTaskButton()
        setupDeleteAllDataButton()
        setupAddAllDataButton()
    }
    
    
    func setupResetDataButton() {
        resetDataButton.setTitle("Reset", for: .normal)
        resetDataButton.setTitleColor(.white, for: .normal)
        resetDataButton.backgroundColor = .colorAccent
        resetDataButton.addAction(
            UIAction { [weak self] _ in self?.showResetConfirmation() },
            for: .touchUpInside)
        view.addSubview(resetDataButton)
        resetDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resetDataButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            resetDataButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -25)
        ])
    }
    
    func setupCancelTaskButton() {
        cancelTaskButton.setTitle("CancelTask", for: .normal)
        cancelTaskButton.setTitleColor(.white, for: .normal)
        cancelTaskButton.backgroundColor = .colorAccent
        cancelTaskButton.addAction(
            UIAction { _ in self.cancelTask() },
            for: .touchUpInside)
        view.addSubview(cancelTaskButton)
        cancelTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelTaskButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            cancelTaskButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 25)
        ])
    }
    
    func setupDeleteAllDataButton() {
        deleteAllDataButton.setTitle("Delete All", for: .normal)
        deleteAllDataButton.setTitleColor(.white, for: .normal)
        deleteAllDataButton.backgroundColor = .colorAccent
        deleteAllDataButton.addAction(
            UIAction { _ in self.deleteAll() },
            for: .touchUpInside)
        view.addSubview(deleteAllDataButton)
        deleteAllDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteAllDataButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            deleteAllDataButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
            constant: 50)
        ])
    }
    
    func setupAddAllDataButton() {
        addAllDataButton.setTitle("Add All", for: .normal)
        addAllDataButton.setTitleColor(.white, for: .normal)
        addAllDataButton.backgroundColor = .colorAccent
        addAllDataButton.addAction(
            UIAction { _ in self.addAllData() },
            for: .touchUpInside)
        view.addSubview(addAllDataButton)
        addAllDataButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addAllDataButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            addAllDataButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: 75)
        ])
    }
    
    func resetData() {
        guard let realm = RealmManager.shared.realm
        else { return }
        
        RealmManager.shared.cancelInitializeTask()

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//
//            RealmManager.shared.asyncTransactionIdList.forEach { id in
//                print("asyncTransactionIdList id = \(id)")
//                try? realm.cancelAsyncWrite(id)
//            }
            
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                print("realm write 오류")
            }
            
            // 운동데이터 DB 입력
            RealmManager.shared.initializeRealmExercise()
            // 운동데이터 이미지 다운 및 DB 입력
            RealmManager.shared.initializeTask = Task { await RealmManager.shared.initializeRealmExerciseImages() }
            
        }
        
    }
    
    func cancelTask() {
        guard let realm = RealmManager.shared.realm
        else { return }
        
        // 작업중인 Realm 비동기 Task를 취소
        RealmManager.shared.cancelInitializeTask()
        
//        RealmManager.shared.asyncTransactionIdList.forEach { id in
//            print("asyncTransactionIdList id = \(id)")
//            try? realm.cancelAsyncWrite(id)
//        }
    }
    
    func deleteAll() {
        guard let realm = RealmManager.shared.realm
        else { return }
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("realm write 오류")
        }
    }
    
    func addAllData() {
        RealmManager.shared.initializeRealmExercise() // 운동데이터 DB 입력
        RealmManager.shared.initializeTask = Task { await RealmManager.shared.initializeRealmExerciseImages() } // 운동데이터 이미지 다운 및 DB 입력
    }

    
    
    private func showResetConfirmation() {
        let alertController = UIAlertController(
            title: "데이터 초기화",
            message: "정말 데이터를 초기화 하시겠습니까?\n지금까지 작성한 데이터가 모두 삭제됩니다.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            self?.resetData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

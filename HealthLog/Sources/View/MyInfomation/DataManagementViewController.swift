//
//  DataManagementViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 9/11/24.
//

import UIKit

class DataManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMain()
        setupTableView()
    }
    
    private func setupMain() {
        title = "데이터 관리"
        view.backgroundColor = .color1E1E1E
        self.navigationController?.setupBarAppearance()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .color1E1E1E
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(
                equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManagementCellOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell", for: indexPath)
        let option = DataManagementCellOption.allCases[indexPath.row]
        cell.textLabel?.text = option.rawValue
        cell.textLabel?.font = UIFont.font(.pretendardMedium, ofSize: 16)
        cell.backgroundColor = .colorSecondary
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = DataManagementCellOption.allCases[indexPath.row]
        option.performAction(vc : self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table Cell Enum
    
    private enum DataManagementCellOption: String, CaseIterable {
        case rollBack = "데이터 초기화"
        
        func performAction(vc: DataManagementViewController) {
            switch self {
                case .rollBack: vc.rollBack()
            }
        }
    }
    
    // MARK: - Table PerformAction
    
    private func rollBack() {
        let alertController = UIAlertController(
            title: "데이터를 초기화 하시겠습니까?",
            message: "지금까지 작성한 데이터가 모두 삭제됩니다.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "초기화", style: .destructive) {
            [weak self] _ in self?.resetData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Sub Methods
    
    private func resetData() {
        guard let realm = RealmManager.shared.realm
        else { return }
        
        RealmManager.shared.cancelInitializeTask()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            do {
                try realm.write {
                    realm.deleteAll()
                }
            } catch {
                print("realm deleteAll 오류")
            }
            RealmManager.shared.initializeRealmExercise()
            RealmManager.shared.initializeTask = Task {
                await RealmManager.shared.initializeRealmExerciseImages()
            }
        }
    }
    
}


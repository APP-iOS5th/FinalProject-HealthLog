//
//  RoutineDetailViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/28/24.
//

import UIKit

class RoutineDetailViewController: UIViewController {
    
    var routine: Routine?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .color1E1E1E
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineDetailTableViewCell.self, forCellReuseIdentifier: RoutineDetailTableViewCell.cellId)
        tableView.register(RoutineDetailTableHeaderView.self, forHeaderFooterViewReuseIdentifier: RoutineDetailTableHeaderView.cellId)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(routine)
        self.navigationItem.title = routine?.name ?? "루틴 이름"
        setupUI()

     
    }
    
    func setupUI() {
        self.view.backgroundColor = .color1E1E1E
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    
}

extension RoutineDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineDetailTableHeaderView.cellId) as! RoutineDetailTableHeaderView
        header.configure(with: routine?.exercises[section].exercise?.name ?? "" )
        return header
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return routine?.exercises.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: RoutineDetailTableViewCell.cellId, for: indexPath) as! RoutineDetailTableViewCell
        
        cell.selectionStyle = .none
        return cell
    }
    
    
    
}

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
        tableView.register(RoutineDetailViewCell.self, forCellReuseIdentifier: RoutineDetailViewCell.cellId)
        tableView.register(RoutineDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: RoutineDetailHeaderView.cellId)
        tableView.register(RoutineDetailFooterView.self, forHeaderFooterViewReuseIdentifier: RoutineDetailFooterView.cellId)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let routine = routine {
            return routine.exercises.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineDetailHeaderView.cellId) as! RoutineDetailHeaderView
        header.configure(with: routine?.exercises[section].exercise?.name ?? "" )
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineDetailFooterView.cellId) as! RoutineDetailFooterView
        return footer
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let routine = routine {
            return routine.exercises[section].sets.count
            
        }
        return 0
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: RoutineDetailViewCell.cellId, for: indexPath) as! RoutineDetailViewCell
        
        cell.selectionStyle = .none
        
        if let routine = routine {
            cell.configure(with: routine.exercises[indexPath.section].sets[indexPath.row])
        }
        return cell
    }
    
    
    
}

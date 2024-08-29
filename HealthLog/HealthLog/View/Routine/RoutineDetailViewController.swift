//
//  RoutineDetailViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/28/24.
//

import UIKit

class RoutineDetailViewController: UIViewController {
    
    let routineViewModel: RoutineViewModel
    let index: Int
    
    init(routineViewModel: RoutineViewModel, index: Int) {
        
       
        self.routineViewModel = routineViewModel
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private lazy var rightBarButtonItem : UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "수정", style: .done, target: self, action: #selector(editTapped))
        rightBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Semibold", size: 16) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        return rightBarButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = routineViewModel.routines[index].name
        setupUI()
        
        
    }
    
    func setupUI() {
        self.view.backgroundColor = .color1E1E1E
        self.view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
        
        
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    @objc func editTapped() {
        let  routineEditViewController = RoutineEditViewController()
        self.navigationController?.pushViewController(routineEditViewController, animated: true)
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
        
        return routineViewModel.routines[index].exercises.count
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineDetailHeaderView.cellId) as! RoutineDetailHeaderView
        header.configure(with: routineViewModel.routines[index].exercises[section].exercise?.name ?? "" )
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineDetailFooterView.cellId) as! RoutineDetailFooterView
        return footer
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return routineViewModel.routines[index].exercises[section].sets.count
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: RoutineDetailViewCell.cellId, for: indexPath) as! RoutineDetailViewCell
        
        cell.selectionStyle = .none
        
        
        cell.configure(with: routineViewModel.routines[index].exercises[indexPath.section].sets[indexPath.row])
        
        return cell
    }
    
    
    
}

//
//  GetRoutineViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/28/24.
//

import UIKit
import Combine

class GetRoutineViewController: UIViewController {
    private var selectedRoutine: Routine?
    let viewModel = RoutineViewModel()
    var onRoutineSelected: ((Routine) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "추가된 루틴이 없습니다."
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .color1E1E1E
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(GetRoutineCell.self, forCellReuseIdentifier: GetRoutineCell.cellId)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        isRoutineData()
    }
    
    private func setupBindings() {
        viewModel.$routines
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
    
    private func updateUI() {
        isRoutineData()
        tableView.reloadData()
    }
    
    func didSelectRoutine(_ routine: Routine) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isRoutineData() {
        if viewModel.routines.isEmpty {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = .color1E1E1E
        self.view.tintColor = .white
        
        self.view.addSubview(textLabel)
        self.view.addSubview(tableView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 115),
            self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
}

// MARK: TableViewDelegate, DataSource
extension GetRoutineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GetRoutineCell.cellId, for: indexPath) as! GetRoutineCell
        cell.selectionStyle = .none
        cell.configure(with: viewModel.routines[indexPath.row])
        let routine = self.viewModel.routines[indexPath.row]
        cell.addButtonTapped = { [weak self] in
            self?.onRoutineSelected?(routine)
            self?.dismiss(animated: true)
        }
        return cell
    }
}

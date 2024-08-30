//
//  RoutinesSerchResultsViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/20/24.
//

import UIKit

class RoutineAddSearchResultsViewController: UIViewController, SearchResultCellDelegate {
    
    weak var delegate: SerchResultDelegate?
    
    let viewModel = ExerciseViewModel()
   
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .color1E1E1E
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineAddSearchResultCell.self, forCellReuseIdentifier: RoutineAddSearchResultCell.cellId)
        return tableView
        
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
        setupUI()
    }
    
   
    
    
    func setupUI() {
        self.view.backgroundColor = UIColor.color1E1E1E
        navigationController?.setupBarAppearance()
        //MARK: - addSubview
        
        self.view.addSubview(dividerView)
        self.view.addSubview(tableView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.dividerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            self.tableView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor, constant: 3),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor),
        ])
        
    }
    
    func didTapButton(in cell: RoutineAddSearchResultCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let selectedItem = viewModel.filteredExercises[indexPath.row]
            print("RoutinSearchReslutView: \(selectedItem)")
            delegate?.didSelectItem(selectedItem)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension RoutineAddSearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineAddSearchResultCell.cellId, for: indexPath) as! RoutineAddSearchResultCell
        cell.delegate = self
        cell.configure(with: viewModel.filteredExercises[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

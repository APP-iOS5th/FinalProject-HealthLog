//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit

class RoutineAddExerciseViewController: UIViewController {
    
    let viewModel = ExerciseViewModel()
    var resultsViewController = RoutineSerchResultsViewController()
    private lazy var searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "운동명 거색"
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .colorPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineExerciseListTableViewCell.self, forCellReuseIdentifier: RoutineExerciseListTableViewCell.cellId)
        return tableView
        
    }()
    
    // Test를 위해 빌려옴
   
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ColorSecondary")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
        setupUI()
    }
   
 
    
    func setupUI() {
        self.navigationController?.setupBarAppearance()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "운동을 추가해주세요."
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        tabBarController?.tabBar.isHidden = true
        navigationController?.setupBarAppearance()
        
        
        tableView.isHidden = true
        
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
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        
    }
    
}

extension RoutineAddExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineExerciseListTableViewCell.cellId, for: indexPath) as! RoutineExerciseListTableViewCell
        
                cell.configure(with: viewModel.filteredExercises[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
   
    
    
    
}

extension RoutineAddExerciseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        
    }
}


//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit
import Combine

class RoutineAddExerciseViewController: UIViewController {
    
    let viewModel = ExerciseViewModel()
    var routineName: String?
    private var cancellables = Set<AnyCancellable>()
    var selectedExercises = [String]()
    
    
    var resultsViewController = RoutineSerchResultsViewController()
    private lazy var searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "운동명 거색"
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        return searchController
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
        
        
       
        
        //MARK: - addSubview
        
        self.view.addSubview(dividerView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.dividerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
          
        ])
        
    }
    
}

// 검색 기능
extension RoutineAddExerciseViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        
        
        if let resultcontroller = searchController.searchResultsController as? RoutineSerchResultsViewController {
            resultcontroller.viewModel.filterExercises(by: text)
            resultcontroller.tableView.reloadData()
        }
    }
}

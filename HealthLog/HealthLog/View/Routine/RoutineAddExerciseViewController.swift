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
    
    private let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
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
    
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .color1E1E1E
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
        setupUI()
        setupCollectionView()
    }
    
    func setupUI() {
        self.navigationController?.setupBarAppearance()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "운동을 추가해주세요."
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.view.backgroundColor = .color1E1E1E
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
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RoutineExerciseStepperCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
    }
    
}

extension RoutineAddExerciseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! RoutineExerciseStepperCollectionViewCell
        let item = data[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 345, height: 200)
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

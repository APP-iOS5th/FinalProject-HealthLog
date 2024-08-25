//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit
import Combine

struct AddRoutineExercise {
    let name: String
    var setCount: Int
    var sets: [ExerciseSet]
    
    struct ExerciseSet {
        var weight: Int
        var reps: Int
    }
}

class RoutineAddExerciseViewController: UIViewController {
    
    var exercises: [AddRoutineExercise] = [
        AddRoutineExercise(name: "벤치 프레스", setCount: 4, sets: Array(repeating: AddRoutineExercise.ExerciseSet(weight: 10, reps: 10), count: 4)),
        AddRoutineExercise(name: "스쿼트", setCount: 3, sets: Array(repeating: AddRoutineExercise.ExerciseSet(weight: 20, reps: 5), count: 3))
    ]
    
    
    let viewModel = ExerciseViewModel()
    var routineName: String?
    private var cancellables = Set<AnyCancellable>()
    var selectedExercises = [String]()
    
    var resultsViewController = RoutineSerchResultsViewController()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "운동명 검색"
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
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
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
        
       
        
        collectionView.register(SetCell.self, forCellWithReuseIdentifier: SetCell.identifier)
        collectionView.register(SetCountHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SetCountHeaderView.identifier)
        
        
        self.view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    
}

extension RoutineAddExerciseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises[section].setCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetCell.identifier, for: indexPath) as! SetCell
        cell.setNumberLabel.text = "\(indexPath.item + 1) 세트"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetCountHeaderView.identifier, for: indexPath) as! SetCountHeaderView
        header.titleLabel.text = exercises[indexPath.row].name
        
        return header
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

//
//  RoutineEditViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/29/24.
//

import UIKit

class RoutineEditViewController: UIViewController, SerchResultDelegate {
    
    let routineViewModel = RoutineEditViewModel()
    
    let index: Int
    
    
    
    init(routineViewModel: RoutineViewModel, index: Int) {
        self.routineViewModel.getRoutine(routine: routineViewModel.routines[index])
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var resultsViewController = RoutineSearchResultsViewController()
    
    private lazy var searchController: UISearchController = {
        resultsViewController.delegate = self
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = true
        return searchController
    }()
    
    // MARK: CollectionView
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
        setupUI()
        setupCollectionView()
    }
    
    func setupUI() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "수정하기"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.view.backgroundColor = .color1E1E1E
        tabBarController?.tabBar.isHidden = true

    }
    
    func didSelectItem(_ item: Exercise) {
        let routineExerciseSets: [RoutineExerciseSet] = (1...4).map { index in
            RoutineExerciseSet(order: index, weight: 0, reps: 0)
        }
        routineViewModel.routine.exercises.append(RoutineExercise(exercise: item, sets: routineExerciseSets))
       
        self.collectionView.reloadData()
//        print("RoutinAddView: \(routineViewModel.routine.exercises.count)")
    }
    
    private func setupCollectionView() {
        
        collectionView.register(SetCell.self, forCellWithReuseIdentifier: SetCell.identifier)
        collectionView.register(SetCountHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SetCountHeaderView.identifier)
        collectionView.register(SetDividerFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SetDividerFooterView.identifier)
        
        
        self.view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -20)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    

}


// MARK: CollectionView

extension RoutineEditViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return routineViewModel.routine.exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routineViewModel.routine.exercises[section].sets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetCell.identifier, for: indexPath) as! SetCell
        cell.configure(with: routineViewModel.routine.exercises[indexPath.section].sets[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetDividerFooterView.identifier, for: indexPath) as! SetDividerFooterView
            
            return footer
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetCountHeaderView.identifier, for: indexPath) as! SetCountHeaderView
        header.configure(with: routineViewModel.routine.exercises[indexPath.section])
        
        header.setCountDidChange = { [weak self] newSetCount in
            self?.routineViewModel.updateExerciseSetCount(for: indexPath.section, setCount: newSetCount)
            self?.collectionView.reloadSections(IndexSet(integer: indexPath.section))
        }
        
        header.setDelete = {
            self.routineViewModel.deleteExercise(for: indexPath.section)
            self.collectionView.reloadData()
        }
        return header
    }

    
}

extension RoutineEditViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        
        if let resultcontroller = searchController.searchResultsController as? RoutineSearchResultsViewController {
            resultcontroller.viewModel.filterExercises(by: text)
            resultcontroller.tableView.reloadData()
        }
    }
}

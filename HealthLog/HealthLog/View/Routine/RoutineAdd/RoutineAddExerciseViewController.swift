//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit
import Combine

protocol SerchResultDelegate: AnyObject {
    func didSelectItem(_ item: Exercise)
}

class RoutineAddExerciseViewController: UIViewController, SerchResultDelegate {
    
    
    
    let routineViewModel = RoutineViewModel()
    
    
    let routineName: String
    private var cancellables = Set<AnyCancellable>()
   
    
    var resultsViewController = RoutineSearchResultsViewController()
    
    init(routineName: String) {
        self.routineName = routineName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController: UISearchController = {
        resultsViewController.delegate = self
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = true
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
    private lazy var rightBarButtonItem : UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        rightBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Semibold", size: 16) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        return rightBarButtonItem
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
        setupUI()
        setupCollectionView()
        setupObservers()
        self.hideKeyBoardWenTappedAround()
        
    }
    
    func setupUI() {
        self.navigationController?.setupBarAppearance()
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "운동을 추가해주세요."
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.view.backgroundColor = .color1E1E1E
        tabBarController?.tabBar.isHidden = true
        
        
        
        
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
        collectionView.register(SetDividerFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SetDividerFooterView.identifier)
        
        
        self.view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -20)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func setupObservers() {
        routineViewModel.$isAddRoutineValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }
            .store(in: &cancellables)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.view.endEditing(true)
    }
    
    func didSelectItem(_ item: Exercise) {
        let routineExerciseSets: [RoutineExerciseSet] = (1...4).map { index in
            RoutineExerciseSet(order: index, weight: 0, reps: 0)
        }
        routineViewModel.routine.exercises.append(RoutineExercise(exercise: item, sets: routineExerciseSets))
        routineViewModel.validateExercise()
        self.collectionView.reloadData()
//        print("RoutinAddView: \(routineViewModel.routine.exercises)")
    }
    
    @objc func doneTapped() {
        routineViewModel.addRoutine(routine: Routine(name: routineName, exercises: routineViewModel.routine.exercises.map { $0 }, exerciseVolume: routineViewModel.routine.exerciseVolume ))
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}

// MARK: CollectionView

extension RoutineAddExerciseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return routineViewModel.routine.exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routineViewModel.routine.exercises[section].sets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetCell.identifier, for: indexPath) as! SetCell
        cell.configure(with: routineViewModel.routine.exercises[indexPath.section].sets[indexPath.item])
        cell.change = {
            self.routineViewModel.validateExercise()
        }
        
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


// 검색 기능
extension RoutineAddExerciseViewController: UISearchResultsUpdating {
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


extension RoutineAddExerciseViewController {
    // 키보드 내리기
    func hideKeyBoardWenTappedAround() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
}

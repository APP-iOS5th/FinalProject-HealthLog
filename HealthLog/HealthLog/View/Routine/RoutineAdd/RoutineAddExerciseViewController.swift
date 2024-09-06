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
    
    
    
    let routineViewModel = RoutineAddViewModel()
    
    
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
        searchController.delegate = self
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = true
        searchController.searchBar.showsBookmarkButton = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = resultsViewController
        
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SelectedExerciseCell.self, forCellReuseIdentifier: "selectedExerciseCell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        return tableView
    }()
    
    
    // Test를 위해 빌려옴
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ColorSecondary")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        self.view.addSubview(tableView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.dividerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 13),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -13),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            self.tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 13),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -13),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
            
            
            
        ])
        
    }
    
    func setupObservers() {
        routineViewModel.$isAddRoutineValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }
            .store(in: &cancellables)
        
        routineViewModel.$routineExecrises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func didSelectItem(_ item: Exercise) {
        let routineExerciseSets: [RoutineExerciseSet] = (1...4).map { index in
            RoutineExerciseSet(order: index, weight: -1, reps: -1)
        }
        routineViewModel.routineExecrises.append(RoutineExercise(exercise: item, order: routineViewModel.routineExecrises.count + 1, sets: routineExerciseSets))
        routineViewModel.validateExercise()
        self.tableView.reloadData()
        //        print("RoutinAddView: \(routineViewModel.routine.exercises)")
    }
    
    @objc func doneTapped() {
        routineViewModel.addRoutine(routine: Routine(name: routineName, exercises: routineViewModel.routineExecrises, exerciseVolume: routineViewModel.routine.exerciseVolume ))
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
}

extension RoutineAddExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineViewModel.routineExecrises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedExerciseCell", for: indexPath) as! SelectedExerciseCell
        let exercise = routineViewModel.routineExecrises[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configureRoutine(exercise)
        cell.exerciseIndex = indexPath.row
        
        cell.stackView.repsTextFields.enumerated().forEach { i, repsTextField in
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: repsTextField)
                .compactMap { ($0.object as? UITextField)?.text }
                .sink { text in
                    self.routineViewModel.routineExecrises[indexPath.row].sets[i].reps = Int(text) ?? 0
                    self.routineViewModel.validateExercise()
                }
                .store(in: &cancellables)
        }
        
        cell.stackView.weightTextFields.enumerated().forEach { i, weightTextField in
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: weightTextField)
                .compactMap { ($0.object as? UITextField)?.text }
                .sink { text in
                    self.routineViewModel.routineExecrises[indexPath.row].sets[i].weight = Int(text) ?? 0
                    self.routineViewModel.validateExercise()
                }
                .store(in: &cancellables)
        }
        
        cell.setCountDidChange = { [weak self] (newSetCount: Int) in
            self?.routineViewModel
                .updateExerciseSetCount(
                    for: indexPath.row, setCount: newSetCount)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        cell.deleteButtonTapped = { [weak self] in
            self?.routineViewModel.deleteExercise(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// 검색 기능

extension RoutineAddExerciseViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsBookmarkButton = true
        if let searchResultsController = searchController.searchResultsController as? RoutineSearchResultsViewController {
            searchResultsController.bodypartOptionShowUIChange(true)
            searchResultsController.prepareForDismissal(false)
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if let searchResultsController = searchController.searchResultsController as? RoutineSearchResultsViewController {
            searchResultsController.prepareForDismissal(true)
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsBookmarkButton = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        
        if let resultcontroller = searchController.searchResultsController as? RoutineSearchResultsViewController {
            resultcontroller.viewModel.setSearchText(to: text)
            resultcontroller.tableView.reloadData()
        }
    }
}


// MARK: Drag and Drop Delegate
extension RoutineAddExerciseViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = routineViewModel.routineExecrises[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath,
           let _ = item.dragItem.localObject as? RoutineExercise {
            routineViewModel.moveExercise(from: sourceIndexPath.row, to: destinationIndexPath.row)
            tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
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

//
//  RoutineEditViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/29/24.
//

import UIKit
import RealmSwift
import Combine


enum EditSections: Int {
    case name, execrises, deleteButone
}


class RoutineEditViewController: UIViewController, SerchResultDelegate {
    
    let viewModel = RoutineEditViewModel()
    let index: Int
    let id: ObjectId
    let name: String
    private var cancellables = Set<AnyCancellable>()
    
    init(routineViewModel: RoutineViewModel, index: Int) {
        self.viewModel.getRoutine(routine: routineViewModel.routines[index])
        self.index = index
        self.id = routineViewModel.routines[index].id
        self.viewModel.editNameTextField = viewModel.routine.name
        self.name = viewModel.routine.name
        self.viewModel.routineExecrises = self.viewModel.routine.exercises.map { $0 }
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var resultsViewController = RoutineSearchResultsViewController()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SelectedExerciseCell.self, forCellReuseIdentifier: "selectedExerciseCell")
        tableView.register(DeleteButtonCell.self, forCellReuseIdentifier: DeleteButtonCell.identifier)
        tableView.register(RoutineEditNameTableViewCell.self, forCellReuseIdentifier: RoutineEditNameTableViewCell.identifier)
        tableView.register(RoutineEditHeader.self, forHeaderFooterViewReuseIdentifier: RoutineEditHeader.cellId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 0
        
        
        return tableView
    }()
    
    private lazy var rightBarButtonItem : UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        rightBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Semibold", size: 16) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        return rightBarButtonItem
    }()
    
    
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
    
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupObservers()
        self.viewModel.validateExercise()
        self.hideKeyBoardWenTappedAround()
        
    }
    
    func setupObservers() {
        viewModel.$isAddRoutineValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }
            .store(in: &cancellables)
        
        viewModel.$routineExecrises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "수정하기"
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.view.backgroundColor = .color1E1E1E
        tabBarController?.tabBar.isHidden = true
        
        
        //MARK: - addSubview
        
        self.view.addSubview(tableView)
        
        
        
        
        //        let padding: CGFloat = 24
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 13),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -13),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor)
            
            
            
            
        ])
    }
    
    
    func didSelectItem(_ item: Exercise) {
        let routineExerciseSets: [RoutineExerciseSet] = (1...4).map { index in
            RoutineExerciseSet(order: index, weight: -1, reps: -1)
        }
        viewModel.routineExecrises.append(RoutineExercise(exercise: item, order: viewModel.routineExecrises.count + 1, sets: routineExerciseSets))
        self.tableView.reloadData()
        self.viewModel.validateExercise()
        
    }
    
    @objc func doneTapped() {

        
        viewModel.updateRoutine(routine: viewModel.routine, index: index)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}

extension RoutineEditViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
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


extension RoutineEditViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let editSection = EditSections(rawValue: section)
        
        switch editSection {
        case .name:
            return 1
        case .execrises:
            return viewModel.routineExecrises.count
            
        case .deleteButone:
            return 1
        default:
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let editSection = EditSections(rawValue: indexPath.section)
        
        switch editSection {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: RoutineEditNameTableViewCell.identifier, for: indexPath) as! RoutineEditNameTableViewCell
            cell.nameTextField.text = self.viewModel.routine.name
            cell.nameTextField
                .textPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.editNameTextField, on: viewModel)
                .store(in: &cancellables)
            
            cell.nameTextField
                .textPublisher
                .receive(on:DispatchQueue.main)
                .sink { [weak self] text in
                    guard let self = self else { return }
                    self.viewModel.routine.name = text
                }
                .store(in: &cancellables)
            
            
            Publishers.CombineLatest(viewModel.isRoutineNameEmptyPulisher, viewModel.isRoutineNameMatchingPulisher)
                .map { !$0 && !$1 }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isValid in
//                    cell.isValidhidden(isValid: isValid)
                    self?.viewModel.validateExercise()
                }
                .store(in: &cancellables)
            
            // 루틴이 이름 존재 할 때
            viewModel.isRoutineNameMatchingPulisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isValid in
                    if let text = cell.nameTextField.text {
                        if isValid && (text != self?.name) {
                            cell.isValidText(text: "이름이 존재 합니다.",color: .red)
                        } else if text.isEmpty && (text != self?.name){
                            cell.isValidText(text: "이름이 비어 있습니다.", color: .red)
                            
                        } else if text == self?.name {
                            cell.isValidText(text: "", color: .clear)
                            
                        }
                        else {
                            cell.isValidText(text: "사용 가능한 이름 입니다.", color: .green)
                        }
                        
                    }
                }
                .store(in: &cancellables)
            
            cell.selectionStyle = .none
            
            return cell
        case .execrises:
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectedExerciseCell", for: indexPath) as! SelectedExerciseCell
            let exercise = viewModel.routineExecrises[indexPath.row]
            
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.configureRoutine(exercise)
            cell.exerciseIndex = indexPath.row
            
            cell.stackView.repsTextFields.enumerated().forEach { i, repsTextField in
                NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: repsTextField)
                    .compactMap { ($0.object as? UITextField)?.text }
                    .sink { text in
                        self.viewModel.routineExecrises[indexPath.row].sets[i].reps = Int(text) ?? 0
                        self.viewModel.validateExercise()
                    }
                    .store(in: &cancellables)
            }
            
            
            cell.stackView.weightTextFields.enumerated().forEach { i, weightTextField in
                NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: weightTextField)
                    .compactMap { ($0.object as? UITextField)?.text }
                    .sink { text in
                        self.viewModel.routineExecrises[indexPath.row].sets[i].weight = Int(text) ?? 0
                        self.viewModel.validateExercise()
                    }
                    .store(in: &cancellables)
            }
            
            cell.setCountDidChange = { [weak self] (newSetCount: Int) in
                self?.viewModel
                    .updateExerciseSetCount(
                        for: indexPath.row, setCount: newSetCount)
                self?.tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            cell.deleteButtonTapped = { [weak self] in
                self?.viewModel.deleteExercise(at: indexPath.row)
            }
            return cell
            
        case .deleteButone:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeleteButtonCell.identifier, for: indexPath) as! DeleteButtonCell
            
            cell.delete = {
                //                self.viewModel.deleteRoutine(id: self.id)
                self.navigationController?.popToRootViewController(animated: true)
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let editSection = EditSections(rawValue: indexPath.section)
        
        switch editSection {
        case.name:
            return UITableView.automaticDimension
        case.execrises:
            return UITableView.automaticDimension
        case.deleteButone:
            return 50
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let editSection = EditSections(rawValue: section)
        
        
        switch editSection {
        case.name:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineEditHeader.cellId) as! RoutineEditHeader
            header.configure(with: "루틴 이름")
            return header
        case.execrises:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RoutineEditHeader.cellId) as! RoutineEditHeader
            header.configure(with: "루틴 운동")
            return header
        case.deleteButone:
            return nil
        default:
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let editSection = EditSections(rawValue: section)
        
        switch editSection {
        case.name, .execrises:
            return 32
      
        case.deleteButone:
            return 0
        default:
            return 0
        }
    }
    
}


// MARK: Drag and Drop Delegate
extension RoutineEditViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let editSection = EditSections(rawValue: indexPath.section)
        if editSection == .name || editSection == .deleteButone {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = viewModel.routineExecrises[indexPath.row]
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if let destinationIndexPath = destinationIndexPath, let editSection = EditSections(rawValue: destinationIndexPath.section) {
            if editSection == .name || editSection == .deleteButone {
                return UITableViewDropProposal(operation: .cancel)
            }
        }
        
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        if let editSection = EditSections(rawValue: destinationIndexPath.section), editSection == .name || editSection == .deleteButone {
            return
        }
        
        
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath,
           let _ = item.dragItem.localObject as? RoutineExercise {
            viewModel.moveExercise(from: sourceIndexPath.row, to: destinationIndexPath.row)
            tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        }
    }
}




extension RoutineEditViewController {
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

//
//  AddScheduleViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit
import Combine

class AddScheduleViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    let dividerView = UIView()
    let tableView = UITableView()
    var selectedDate: Date?
    private var exerciseViewModel = ExerciseViewModel()
    private var addScheduleViewModel = AddScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: init(date: Date) 저장형식 논의
//    init(date: Date) {
//        self.selectedDate = date
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupDividerView()
        setupTableView()
        setupConstraints()
        view.backgroundColor = .color1E1E1E
        
        searchController.searchBar.delegate = self
        bindViewModel()
        setupKeyboard()
        hideKeyBoardWhenTappedScreen()
    }

    private func bindViewModel() {
        exerciseViewModel.$filteredExercises
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                (self?.searchController.searchResultsController as? SearchResultsViewController)?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        addScheduleViewModel.$selectedExercises
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        addScheduleViewModel.$isValid
            .receive(on: RunLoop.main)
            .sink { [weak self] isValid in
                self?.navigationItem.rightBarButtonItem?.isEnabled = isValid
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        self.title = "오늘 할 운동 추가"
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .color1E1E1E
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                .font: UIFont(name: "Pretendard-Semibold", size: 20) as Any
            ]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        let leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissView))
        leftBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Semibold", size: 16) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        rightBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Semibold", size: 16) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
        
    private func setupSearchController() {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsViewController {
            searchResultsController.onExerciseSelected = { [weak self] exercise in
                self?.addSelectedExercise(exercise)
            }
            searchResultsController.viewModel = exerciseViewModel
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        //searchController.searchResultsUpdater = self
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = .white
            }
        }
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupDividerView() {
        dividerView.backgroundColor = .colorSecondary
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
    }
    
    private func setupTableView() {
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
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        headerView.backgroundColor = .clear
        
        let getRoutineButton = UIButton(type: .system)
        getRoutineButton.setTitle("루틴 불러오기", for: .normal)
        getRoutineButton.backgroundColor = .colorAccent
        getRoutineButton.layer.cornerRadius = 12
        getRoutineButton.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        getRoutineButton.tintColor = .white
        getRoutineButton.translatesAutoresizingMaskIntoConstraints = false
        getRoutineButton.addTarget(self, action: #selector(routineButtonTapped), for: .touchUpInside)
        headerView.addSubview(getRoutineButton)
        
        NSLayoutConstraint.activate([
            getRoutineButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            getRoutineButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 13),
            getRoutineButton.widthAnchor.constraint(equalToConstant: 345),
            getRoutineButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func routineButtonTapped() {
        let routineVC = RoutinesViewController()
        routineVC.modalPresentationStyle = .pageSheet
        self.present(routineVC, animated: true, completion: nil)
    }
    
    @objc func doneTapped() {
        let date = Date() // 임시로 현재 날짜 넣음, scheduleviewcontroller에서 받아오는 날짜 사용 예정
        addScheduleViewModel.saveSchedule(for: date) // 스케줄 저장
        navigationController?.popViewController(animated: true)
    }
    
    func addSelectedExercise(_ exercise: Exercise) {
        addScheduleViewModel.addExercise(exercise)
    }
    
    func removeSelectedExercise(at index: Int) {
        addScheduleViewModel.removeExercise(at: index)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드가 나타날 때 테이블 뷰의 인셋 조정
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        // 현재 선택된 텍스트 필드를 키보드 위로 이동
        if let activeField = view.currentFirstResponder() {
            let rect = tableView.convert(activeField.frame, from: activeField.superview)
            tableView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    // 키보드가 사라질 때 테이블 뷰의 인셋 초기화
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    func hideKeyBoardWhenTappedScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapHandler() {
        self.view.endEditing(true)
    }
}

// MARK: TableView Delegate
extension AddScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addScheduleViewModel.selectedExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedExerciseCell", for: indexPath) as! SelectedExerciseCell
        let exercise = addScheduleViewModel.selectedExercises[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(exercise)
        cell.exerciseIndex = indexPath.row
        cell.updateSet = { [weak self] setIndex, weight, reps in
            self?.addScheduleViewModel.updateSet(at: indexPath.row, setIndex: setIndex, weight: weight, reps: reps)
        }

        cell.stackView.repsTextFields.enumerated().forEach { i, repsTextField in
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: repsTextField)
                .compactMap { ($0.object as? UITextField)?.text }
                .sink { text in
                    print("repsTextField change")
                    self.addScheduleViewModel.selectedExercises[indexPath.row].sets[i].reps = Int(text) ?? 0
                }
                .store(in: &cancellables)
        }
        
        cell.stackView.weightTextFields.enumerated().forEach { i, weightTextField in
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: weightTextField)
                .compactMap { ($0.object as? UITextField)?.text }
                .sink { text in
                    print("weightTextField change")
                    self.addScheduleViewModel.selectedExercises[indexPath.row].sets[i].weight = Int(text) ?? 0
                }
                .store(in: &cancellables)
        }
        
        cell.setCountDidChange = { [weak self] (newSetCount: Int) in
            print("newSetCount - \(newSetCount)")
            self?.addScheduleViewModel
                .updateExerciseSetCount(
                    for: indexPath.row, setCount: newSetCount)
            
            print("cell.currentSetCount - \(cell.currentSetCount)")
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }

        cell.deleteButtonTapped = { [weak self] in
            self?.removeSelectedExercise(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: SearchBar Delegate
extension AddScheduleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        exerciseViewModel.setSearchText(to: searchText)
    }
}

// MARK: Drag and Drop Delegate
extension AddScheduleViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = addScheduleViewModel.selectedExercises[indexPath.row]
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
           let _ = item.dragItem.localObject as? ScheduleExercise {
            addScheduleViewModel.moveExercise(from: sourceIndexPath.row, to: destinationIndexPath.row)
            tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
        }
    }
}

extension UIView {
    func currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for subview in self.subviews {
            if let firstResponder = subview.currentFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

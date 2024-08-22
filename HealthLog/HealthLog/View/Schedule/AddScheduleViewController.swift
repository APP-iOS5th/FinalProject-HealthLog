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
    //var selectedExercises = [String]()
    
    private var exerciseViewModel = ExerciseViewModel()
    private var addScheduleViewModel = AddScheduleViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupDividerView()
        setupTableView()
        setupConstraints()
        view.backgroundColor = .colorPrimary
        
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
        
        // 사용자가 선택한 운동 목록이 변경될 때마다 테이블 뷰를 갱신하고, 완료 버튼의 상태를 갱신
        addScheduleViewModel.$selectedExercises
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.validateCompletionButton()
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        self.title = "오늘 할 운동 추가"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            .font: UIFont(name: "Pretendard-Semibold", size: 20) as Any
        ]
        
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
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // 모든 운동 세트의 필드가 채워졌는지 확인 -> 완료버튼활성화
    func validateCompletionButton() {
        let allFieldsFilled = addScheduleViewModel.selectedExercises.allSatisfy { exercise in
            if let indexPath = addScheduleViewModel.selectedExercises.firstIndex(where: { $0.exerciseName == exercise.exerciseName }) {
                let cell = tableView.cellForRow(at: IndexPath(row: indexPath, section: 0)) as? SelectedExerciseCell
                return cell?.areAllFieldsFilled() ?? false
            }
            return false
        }
        navigationItem.rightBarButtonItem?.isEnabled = !addScheduleViewModel.selectedExercises.isEmpty && allFieldsFilled
    }
    
    private func setupSearchController() {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsViewController {
            searchResultsController.onExerciseSelected = { [weak self] exerciseName in
                self?.addSelectedExercise(exerciseName)
            }
            searchResultsController.viewModel = exerciseViewModel
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        
        // UITextField는 공개적으로 제공되는 프로퍼티가 아니기 때문에, value(forKey:)를 사용해 이 내부 요소에 접근
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SelectedExerciseCell.self, forCellReuseIdentifier: "selectedExerciseCell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
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
    
    func addSelectedExercise(_ exerciseName: String) {
        addScheduleViewModel.addExercise(exerciseName)
        validateCompletionButton()
    }
    
    func removeSelectedExercise(at index: Int) {
        addScheduleViewModel.removeExercise(at: index)
        validateCompletionButton()
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

extension AddScheduleViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addScheduleViewModel.selectedExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedExerciseCell", for: indexPath) as! SelectedExerciseCell
        let exercise = addScheduleViewModel.selectedExercises[indexPath.row]
        let setCount = exercise.sets.isEmpty ? 4 : exercise.sets.count
        // print("Configuring cell at 인덱스: \(indexPath.row), 운동이름: \(exercise.exerciseName)")
        cell.configure(with: exercise.exerciseName, setCount: setCount)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        // 셀의 삭제버튼이 탭되었을 때 해당인덱스에서 운동 제거하는 클로저
        cell.deleteButtonTapped = { [weak self] in
            self?.removeSelectedExercise(at: indexPath.row)
        }
        // 셀의 세트 수, 내용을 수정할 때 뷰모델의 운동데이터 업데이트하는 클로저
        cell.setsDidChange = { [weak self] sets in
            self?.addScheduleViewModel.updateExerciseSet(for: indexPath.row, sets: sets)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        exerciseViewModel.setSearchText(to: searchText)
    }
}


extension UIView {
    // 현재 포커스를 받고 있는 뷰(텍스트 필드) 찾기
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
    // 해당 뷰의 부모 뷰 컨트롤러 찾기
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

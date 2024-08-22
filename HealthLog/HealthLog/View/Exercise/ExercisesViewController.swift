//
//  ExerciseViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import UIKit

class ExercisesViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let containerStackView = UIStackView()
    private let testStackView = CustomBodyPartButtonStackView()
    
    private let addButton = UIButton(type: .custom)
    private let dividerView = UIView()
    private let tableView = UITableView()
    
    let testView = UIView()
    var stackViewHeight: CGFloat?
    var stackViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        setupTestStackView()
        setupDivider()
        setupTableView()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if stackViewHeight == nil {
            stackViewHeight = testStackView.bounds.height
            stackViewHeightConstraint = testStackView
                .heightAnchor.constraint(equalToConstant: 0)
            stackViewHeightConstraint!.isActive = true
        }
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        title = "운동 목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // MARK: addButton
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "+"
        buttonConfig.baseBackgroundColor = .colorAccent
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .fixed
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 8, bottom: 2, trailing: 8)
        addButton.configuration = buttonConfig
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: tempStepperButton
        
        let tempStepperButton = UIBarButtonItem(title: "Stepper", style: .plain, target: self, action: #selector(tempStepperButtonTapped))
        self.navigationItem.leftBarButtonItem = tempStepperButton
    }
    
    private func setupSearchController() {

        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.scopeButtonTitles = BodyPartOption.allName
        searchBar.showsScopeBar = true
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black

        let placeHolder = NSAttributedString(
            string: "운동명 입력",
            attributes: [NSAttributedString.Key.foregroundColor:
                            UIColor.lightGray]
        )
        searchBar.searchTextField.attributedPlaceholder = placeHolder
        searchBar.searchTextField.textColor = .white
        
        definesPresentationContext = true
        
    }
    
    private func setupTestStackView() {
        view.addSubview(testStackView)
        testStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            testStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        
//        // hidden
//        self.testStackView.arrangedSubviews
//            .forEach {$0.isHidden = true}
    }
    
    func setupDivider() {
        dividerView.backgroundColor = UIColor.lightGray // 구분선 색상 설정
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: testStackView.bottomAnchor),
            dividerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1)
        ])
    }
    
    func setupTableView() {
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: "ExerciseCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBindings() {
        // MARK: Search Exercises Reload
        viewModel.$filteredExercises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                print("tableView - reload")
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
        searchController
            .publisher(for: \.isActive)
            .sink { print("searchController - \($0)") }
            .store(in: &cancellables)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//        viewModel.setOption(to: .all)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let selectedOption: BodyPartOption
        if selectedScope == 0 {
            selectedOption = .all
        } else {
            let bodyPart = BodyPart.allCases[selectedScope - 1]
            selectedOption = .bodyPart(bodyPart)
        }
        print("searchBar selectedScope - \(selectedOption.name)")
        viewModel.setOption(to: selectedOption)
    }
    
    // MARK: - UISearchControllerDelegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("Search Controller will become active")
        animateContainerViewHeight(isVisible: true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("Search Controller will be dismissed")
        animateContainerViewHeight(isVisible: false)
    }
    
    private func animateContainerViewHeight(isVisible: Bool) {
        if isVisible {
            self.stackViewHeightConstraint?.constant = self.stackViewHeight!
            self.stackViewHeightConstraint?.isActive = true
        } else {
            self.stackViewHeightConstraint?.constant = 0
            self.stackViewHeightConstraint?.isActive = true
        }
        
        print("stackViewHeightConstraint - \(String(describing: stackViewHeightConstraint?.constant))")
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    // hidden
    private func animateContainerViewHeight2(isVisible: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.testStackView.arrangedSubviews
                .forEach {$0.isHidden = !isVisible}
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.setSearchText(to: searchText)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView Count - \(viewModel.filteredExercises.count)")
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseListCell
        
        let exercise = viewModel.filteredExercises[indexPath.row]
        cell.configure(with: exercise)
        cell.configurePushDetailViewButton(with: exercise, navigationController: self.navigationController!)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: Methods
    
    @objc func addButtonTapped() {
        print("addButtonTapped!")
        let vc = ExercisesAddViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func tempStepperButtonTapped() {
        print("tempButtonTapped!")
        let vc = TempViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        viewModel.filterExercises(by: "")
//        searchBar.resignFirstResponder()
//    }
    
}

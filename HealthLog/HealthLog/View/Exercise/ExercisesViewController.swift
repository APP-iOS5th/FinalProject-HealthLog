//
//  ExerciseViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import UIKit

class ExercisesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Declare
    private var cancellables = Set<AnyCancellable>()
    let viewModel = ExerciseViewModel()
    
    let addButton = UIButton(type: .custom)
    let searchBar = UISearchBar()
    let dividerView = UIView()
    let tableView = UITableView()
    
    // 샘플 데이터
    var data = ["Apple", "Banana", "Cherry", "Date",]
    var filteredData: [String] = []
    
    var filteredExercises: [Exercise] = []
    
    //MARK: - Init
    
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
        
        filteredExercises = viewModel.exercises
        
        setupNavigationBar()
        setupSearchBarView()
        setupDivider()
        setupTableView()
        
        viewModel.$exercises.sink { [weak self] _ in
            self?.filteredExercises = self?.viewModel.exercises ?? []
            self?.tableView.reloadData()
        }.store(in: &cancellables)
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
    }
    
    func setupSearchBarView() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .colorSecondary
        searchBar.searchTextField.textColor = .white
        let placeHolder = NSAttributedString(
            string: "검색어 입력",
            attributes: [NSAttributedString.Key.foregroundColor:
                            UIColor.lightGray])
        searchBar.searchTextField.attributedPlaceholder = placeHolder
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupDivider() {
        dividerView.backgroundColor = UIColor.lightGray // 구분선 색상 설정
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor),
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
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // 검색어가 비어있을 때 모든 데이터를 보여줌
            print("searchBar - empty")
            filteredExercises = viewModel.exercises
        } else {
            // 검색어에 해당하는 데이터만 필터링
            print("searchBar - filter")
            filteredExercises = viewModel.exercises.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseListCell
        cell.configure(with: filteredExercises[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: Methods
    
    @objc func addButtonTapped() {
        print("addButtonTapped!")
        let vc = TempViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredData = data
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}

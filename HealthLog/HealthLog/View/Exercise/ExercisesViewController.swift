//
//  ExerciseViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class ExercisesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Declare
    
    let viewModel = ExerciseViewModel()
    
    let searchBar = UISearchBar()
    let dividerView = UIView()
    let tableView = UITableView()
    
    // 샘플 데이터
    var data = ["Apple", "Banana", "Cherry", "Date",]
    var filteredData: [String] = []
    
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
        
        setupNavigationBar()
        setupSearchBarView()
        setupDivider()
        setupTableView()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        title = "운동 목록"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let rightBarButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(addButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupSearchBarView() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "검색어 입력"
        searchBar.backgroundColor = .black
        searchBar.translatesAutoresizingMaskIntoConstraints = false
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
            dividerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupTableView() {
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: "ExerciseCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none // 기본 구분선 제거
        tableView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // 셀 간의 여백 설정
        tableView.separatorInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30) // 셀 간의 여백 설정
        
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
            filteredData = data
        } else {
            filteredData = data.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseListCell
        cell.configure(with: viewModel.exercises[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let margin: CGFloat = 10
//        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
    }
    
    // MARK: Methods
    
    @objc func addButtonTapped() {
        print("addButtonTapped!")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredData = data
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}

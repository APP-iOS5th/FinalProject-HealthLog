//
//  AddScheduleViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class AddScheduleViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    let getRoutineButton = UIButton()
    let dividerView = UIView()
    let tableView = UITableView()
    
    var selectedExercises = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "오늘 할 운동 추가"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissView))
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
//        let textAttributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.white,
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
//        ]
//        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.leftBarButtonItem?.tintColor = .white

        
        if let searchResultsController = searchController.searchResultsController as? SearchResultsViewController {
            searchResultsController.onExerciseSelected = { [weak self] exerciseName in
                self?.addSelectedExercise(exerciseName)
            }
        }
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
        }
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        dividerView.backgroundColor = UIColor(named: "ColorSecondary")
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        getRoutineButton.setTitle("루틴 불러오기", for: .normal)
        getRoutineButton.backgroundColor = UIColor(named: "ColorAccent")
        getRoutineButton.layer.cornerRadius = 12
        getRoutineButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        getRoutineButton.translatesAutoresizingMaskIntoConstraints = false
        getRoutineButton.addTarget(self, action: #selector(routineButtonTapped), for: .touchUpInside)
        view.addSubview(getRoutineButton)
        
        setupTableView()
        setupConstraints()
        
        view.backgroundColor = UIColor(named: "ColorPrimary")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SelectedExerciseCell.self, forCellReuseIdentifier: "selectedExerciseCell")
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    func addSelectedExercise(_ exerciseName: String) {
        selectedExercises.append(exerciseName)
        tableView.reloadData()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            getRoutineButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 13),
            getRoutineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getRoutineButton.widthAnchor.constraint(equalToConstant: 345),
            getRoutineButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: getRoutineButton.bottomAnchor, constant: 13),
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
}

extension AddScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedExercises.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        307
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedExerciseCell", for: indexPath)
        cell.textLabel?.text = selectedExercises[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(named: "ColorSecondary")
        return cell
    }
}

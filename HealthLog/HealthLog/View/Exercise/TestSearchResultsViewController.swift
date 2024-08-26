//
//  TestSearchResultsViewController.swift
//  HealthLog
//
//  Created by user on 8/25/24.
//

import Foundation
import UIKit

class TestSearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel = ExerciseViewModel()
    
    // MARK: 영우 - Exercise 타입으로 변경
    var onExerciseSelected: ((Exercise) -> Void)?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDividerView()
        setupConstraints()
    }
    
    private func setupDividerView() {
        view.addSubview(dividerView)
    }
    
    private func setupTableView() {
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        tableView.backgroundColor = .colorPrimary
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        let exercise = viewModel.filteredExercises[indexPath.row]
        cell.configure(with: exercise)
        cell.selectionStyle = .none
        cell.addButtonTapped = { [weak self] in
            
            // MARK: 영우 - Exercise 타입으로 변경
            self?.onExerciseSelected?(exercise)
            self?.clearSearchAndDismiss()
        }
        return cell
    }
    
    private func clearSearchAndDismiss() {
        if let searchController = self.parent as? UISearchController {
            searchController.searchBar.text = ""
        }
        self.dismiss(animated: true, completion: nil)
    }
}

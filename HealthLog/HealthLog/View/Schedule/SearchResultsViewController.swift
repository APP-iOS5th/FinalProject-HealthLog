//
//  SearchResultsViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    let viewModel = ExerciseViewModel()
    var onExerciseSelected: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        tableView.backgroundColor = UIColor(named: "ColorPrimary")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        107
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        let exercise = viewModel.exercises[indexPath.row]
        cell.configure(with: exercise)
        cell.addButtonTapped = { [weak self] in
            self?.onExerciseSelected?(exercise.name)
        }
        return cell
    }
}

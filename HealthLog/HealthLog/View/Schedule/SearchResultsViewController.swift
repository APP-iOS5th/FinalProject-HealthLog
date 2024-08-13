//
//  SearchResultsViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
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
        return 10 // 개수 수정 필요
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        cell.textLabel?.text = "운동이름 \(indexPath.row)"
        cell.textLabel?.textColor = .white
        cell.addButtonTapped = { [weak self] in
            let exerciseName = cell.textLabel?.text ?? "운동이름"
            self?.onExerciseSelected?(exerciseName)
        }
        return cell
    }
}

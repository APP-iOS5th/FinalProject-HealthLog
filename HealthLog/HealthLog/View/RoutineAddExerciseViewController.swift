//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit

class RoutineAddExerciseViewController: UIViewController {
    var data = ["Apple", "Banana", "Cherry", "Date", "Fig", "Grape"]
    var filteredData: [String]!
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "운동을 추가해주세요."
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "ColorPrimary")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
        
    }()
    
    // Test를 위해 빌려옴
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "운동명 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        searchBar.showsCancelButton = true
        searchBar.barTintColor = .white
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: searchBar.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
            )
            textField.textColor = .white
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
        }
        
        return searchBar
    }()
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ColorSecondary")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
        filteredData = data
        setupUI()
    }
    
    
    func setupUI() {
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        tabBarController?.tabBar.isHidden = true
        navigationController?.setupBarAppearance()
        
        tableView.isHidden = true
        
        //MARK: - addSubview
        self.view.addSubview(textLabel)
        self.view.addSubview(dividerView)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant:  12),
            self.textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 24),
            self.dividerView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            self.searchBar.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor,constant: 13),
            self.searchBar.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.searchBar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 3),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        
    }
    
}

extension RoutineAddExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    
    
}


extension RoutineAddExerciseViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = data
        } else {
            filteredData = data.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = data
        tableView.reloadData()
    }

}

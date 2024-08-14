//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit

class RoutineAddExerciseViewController: UIViewController {
    
    let viewModel = ExerciseViewModel()
    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "운동을 추가해주세요."
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .colorPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineExerciseListTableViewCell.self, forCellReuseIdentifier: RoutineExerciseListTableViewCell.cellId)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineExerciseListTableViewCell.cellId, for: indexPath) as! RoutineExerciseListTableViewCell
        
                cell.configure(with: viewModel.filteredExercises[indexPath.row])
        cell.selectionStyle = .none
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
        viewModel.filterExercises(by: searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.filterExercises(by: "")
        tableView.reloadData()
    }

}

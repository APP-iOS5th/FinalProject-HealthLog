//
//  RoutineViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class RoutinesViewController: UIViewController {
    
    
    let viewModel = RoutineViewModel()
    
    
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "추가된 루틴이 없습니다."
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "루틴 검색"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.hidesBottomBarWhenPushed = true
        
        return searchController
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let buttonAction = UIAction { _ in
            print("addButton 클릭")
            let routineAddNameViewController = RoutineAddNameViewController()
            self.navigationController?.pushViewController(routineAddNameViewController, animated: true)
        }
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill")?.withTintColor(.white, renderingMode: .alwaysTemplate), primaryAction: buttonAction)
        barButton.tintColor = UIColor(named: "ColorAccent")
        return barButton
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .color1E1E1E
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineCell.self, forCellReuseIdentifier: RoutineCell.cellId)
        
       return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.fillteRoutines(by: "")
        isRoutineData()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        self.tableView.reloadData()
        isRoutineData()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    func isRoutineData() {
        if viewModel.routines.isEmpty {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
    }
    func setupUI() {
        
        self.view.backgroundColor = .color1E1E1E
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "루틴"
        self.view.tintColor = .white
        
        
        
        let backbarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbarButtonItem
        
        //MARK: - addSubview
        self.view.addSubview(textLabel)
        self.view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = self.addButton
        
        let safeArea = self.view.safeAreaLayoutGuide
        //MARK: - NSLayoutconstraint
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -20),
            
            
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 115),
            self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
    }
    
    
   
    
    
}


extension RoutinesViewController: UISearchResultsUpdating {
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        viewModel.fillteRoutines(by: text)
        self.tableView.reloadData()
        
        
    }
    
    
}

//tableView
extension RoutinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.viewModel.filteredRoutines.count : self.viewModel.routines.count
//        self.viewModel.routines.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.cellId, for: indexPath) as! RoutineCell
        cell.selectionStyle = .none
//        cell.configure(with: viewModel.routines[indexPath.row])
        if isFiltering {
            cell.configure(with: viewModel.filteredRoutines[indexPath.row])
        } else {
            cell.configure(with: viewModel.routines[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("cell 선택 \(indexPath.row )")
        let routineDetailViewController = RoutineDetailViewController(routineViewModel: viewModel, index: indexPath.row)
        self.navigationController?.pushViewController(routineDetailViewController, animated: true)
    }
    
    
}

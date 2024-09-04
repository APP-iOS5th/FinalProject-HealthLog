//
//  RoutineViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import Combine

class RoutinesViewController: UIViewController {
    
    
    let viewModel = RoutineViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    

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
        let buttonAction = UIAction { [weak self] _ in
            print("addButton 클릭")
            let routineAddNameViewController = RoutineAddNameViewController()
            self?.navigationController?.pushViewController(routineAddNameViewController, animated: true)
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
        isRoutineData()
        setupUI()
        viewModel.syncRotuine() //임시 사용
        setupObservers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        isRoutineData()
        print("viewWillApper")
        
        viewModel.syncRotuine() //임시 사용
        setupObservers()
        self.tableView.reloadData()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        print("루틴\(viewModel.routines)")
        print("필터\(viewModel.filteredRoutines)")
        
    }
    
    func setupObservers() {
        
        viewModel.$filteredRoutines
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
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
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor),
            
            
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 115),
            self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
    }
        
}


extension RoutinesViewController: UISearchResultsUpdating {

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
        return self.viewModel.filteredRoutines.count
//        self.viewModel.routines.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.cellId, for: indexPath) as! RoutineCell
        cell.selectionStyle = .none
//        cell.configure(with: viewModel.routines[indexPath.row])
      
            cell.configure(with: viewModel.filteredRoutines[indexPath.row])
        cell.addbutton = {
            self.viewModel.addScheduleExercise(index: indexPath.row)
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

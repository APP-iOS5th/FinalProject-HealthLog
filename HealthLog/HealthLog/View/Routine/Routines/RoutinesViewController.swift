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
        // MARK: addButton
        let addButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .small)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        addButton.setImage(plusImage, for: .normal)
        addButton.backgroundColor = .colorAccent
        addButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: addButton)

        barButton.tintColor = UIColor(named: "ColorAccent")
        return barButton
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .color1E1E1E
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineCell.self, forCellReuseIdentifier: RoutineCell.cellId)
        tableView.sectionFooterHeight = 13
       return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        print("viewWillApper")
        setupObservers()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    func setupObservers() {
        
        viewModel.$filteredRoutines
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$routines
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] routines in
                if routines.isEmpty {
                    self?.tableView.isHidden = true
                } else {
                    self?.tableView.isHidden = false
                }
            }.store(in: &cancellables)
        
        
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
        self.view.addSubview(dividerView)
        
        self.navigationItem.rightBarButtonItem = self.addButton
        
        let safeArea = self.view.safeAreaLayoutGuide
        //MARK: - NSLayoutconstraint
        NSLayoutConstraint.activate([
            
            self.dividerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            self.tableView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor, constant: 13),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor),
            
            
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 115),
            self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
    }
    
    @objc func addButtonTapped() {
        let routineAddNameViewController = RoutineAddNameViewController()
        self.navigationController?.pushViewController(routineAddNameViewController, animated: true)
    }
    
    
    func showToast(message : String, font: UIFont = UIFont.font(.pretendardSemiBold, ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2, delay: 0.3, options: .curveEaseOut, animations: {
                 toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
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
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredRoutines.count
//        self.viewModel.routines.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.cellId, for: indexPath) as! RoutineCell
        cell.selectionStyle = .none
        cell.configure(with: viewModel.routines[indexPath.row])
      
            cell.configure(with: viewModel.filteredRoutines[indexPath.row])
        cell.addbutton = {
            self.viewModel.addScheduleExercise(index: indexPath.row)
            self.showToast(message: "스케줄에 추가 되었습니다.")
            cell.addExerciseButton.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                cell.addExerciseButton.isEnabled = true
                    }
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

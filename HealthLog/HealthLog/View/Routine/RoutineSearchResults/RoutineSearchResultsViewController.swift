//
//  RoutinesSerchResultsViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/20/24.
//

import UIKit
import Combine

class RoutineSearchResultsViewController: UIViewController, SearchResultCellDelegate {
    
    weak var delegate: SerchResultDelegate?
    
    let viewModel = ExerciseViewModel()
   
    let searchOptionStackView = SearchBodyPartStackView()
    
    private var cancellables = Set<AnyCancellable>()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .color1E1E1E
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RoutineSearchResultCell.self, forCellReuseIdentifier: RoutineSearchResultCell.cellId)
        return tableView
        
    }()

    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let searchController = self.parent as? UISearchController {
            searchController.searchBar.showsBookmarkButton = false
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetBodyPartsOption()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
     
        setupUI()
        setupBinding()
        self.hideKeyboard()
    }
    
    
    
    private func setupBinding() {
        viewModel.$filteredExercises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
        
        // MARK: SearchBodyPartOption Select
        searchOptionStackView
            .bodyPartOptionPublisher
            .sink { self.viewModel.selectedOption = $0 }
            .store(in: &cancellables)
        
        // MARK: bodypartOptionShowUIChange
        viewModel.$bodypartOptionShow
            .sink { self.bodypartOptionShowUIChange($0) }
            .store(in: &cancellables)
    }

   
 
    
    func setupUI() {
        viewModel.bodypartOptionShow = true

        self.view.backgroundColor = UIColor.color1E1E1E
        navigationController?.setupBarAppearance()
        //MARK: - addSubview
        
        self.view.addSubview(dividerView)
        self.view.addSubview(tableView)
        searchOptionStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchOptionStackView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            searchOptionStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchOptionStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            searchOptionStackView.trailingAnchor.constraint(equalTo:safeArea.trailingAnchor, constant: -16),
            
            self.dividerView.topAnchor.constraint(equalTo: searchOptionStackView.bottomAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            self.tableView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor, constant: 3),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor),
        ])
        
    }
    
    private func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSearchBar(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapOutsideSearchBar(_ gesture: UITapGestureRecognizer) {
        if let searchController = self.parent as? UISearchController {
            if searchController.searchBar.isFirstResponder {
                searchController.searchBar.resignFirstResponder()
            }
        }
    }
    
    
    func didTapButton(in cell: RoutineSearchResultCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let selectedItem = viewModel.filteredExercises[indexPath.row]
            print("RoutinSearchReslutView: \(selectedItem)")
            delegate?.didSelectItem(selectedItem)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func animateBodyPartsHidden(isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.searchOptionStackView.stackContentHidden(isHidden: isHidden)
        }
    }
    
    func resetBodyPartsOption() {
        searchOptionStackView.bodypartButtonList
            .first(where: { $0.bodypartOption == .all })?
            .sendActions(for: .touchUpInside)
    }
    
    func bodypartOptionShowUIChange(_ bodypartOptionShow: Bool) {
        let iconName: String
        guard let searchController = self.parent as? UISearchController else { return }
        let searchBar = searchController.searchBar
        
        if bodypartOptionShow {
            iconName = "menubar.arrow.down.rectangle"
            self.animateBodyPartsHidden(isHidden: false)
            searchBar.becomeFirstResponder()
        } else {
            iconName = "menubar.arrow.up.rectangle"
            self.animateBodyPartsHidden(isHidden: true)
            searchBar.resignFirstResponder()
        }
        
        let icon = UIImage(systemName: iconName)?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        UIView.animate(withDuration: 0.3) {
            searchBar.setImage(icon, for: .bookmark, state: .normal)
        }
    }
    
    func prepareForDismissal(_ close: Bool) {
        tableView.isHidden = close
    }
    
}

extension RoutineSearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoutineSearchResultCell.cellId, for: indexPath) as! RoutineSearchResultCell
        cell.delegate = self
        cell.configure(with: viewModel.filteredExercises[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UISearchBarDelegate
extension RoutineSearchResultsViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        viewModel.bodypartOptionShow.toggle()
    }
    
}

// MARK: UIScrollViewDelegate
extension RoutineSearchResultsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let searchController = self.parent as? UISearchController {
            UIView.animate(withDuration: 0.3) {
                searchController.searchBar.resignFirstResponder()
            }
        }
    }
}


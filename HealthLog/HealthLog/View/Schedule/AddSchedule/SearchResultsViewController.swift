//
//  SearchResultsViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import Foundation
import UIKit
import Combine

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var cancellables = Set<AnyCancellable>()
    var viewModel = ExerciseViewModel()
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
    
    let searchOptionStackView = SearchBodyPartStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bodypartOptionShow = true
        view.backgroundColor = .color1E1E1E
        setupTableView()
        setupSearchOptionStackView()
        setupDividerView()
        setupConstraints()
        setupBinding()
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSearchBar(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
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
    
    @objc private func handleTapOutsideSearchBar(_ gesture: UITapGestureRecognizer) {
        if let searchController = self.parent as? UISearchController {
            if searchController.searchBar.isFirstResponder {
                searchController.searchBar.resignFirstResponder()
            }
        }
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
    
    private func setupSearchOptionStackView() {
        searchOptionStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchOptionStackView)
    }
    
    private func setupDividerView() {
        view.addSubview(dividerView)
    }
    
    private func setupTableView() {
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "searchResultCell")
        tableView.backgroundColor = .color1E1E1E
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchOptionStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchOptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchOptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: searchOptionStackView.bottomAnchor),
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
            self?.onExerciseSelected?(exercise)
            self?.clearSearchAndDismiss()
            self?.prepareForDismissal(true)
        }
        return cell
    }
    
    private func clearSearchAndDismiss() {
        if let searchController = self.parent as? UISearchController {
            searchController.searchBar.text = ""
        }
        self.dismiss(animated: true, completion: nil)
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

// MARK: UISearchBarDelegate
extension SearchResultsViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        viewModel.bodypartOptionShow.toggle()
    }
    
}

// MARK: UIScrollViewDelegate
extension SearchResultsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let searchController = self.parent as? UISearchController {
            UIView.animate(withDuration: 0.3) {
                searchController.searchBar.resignFirstResponder()
            }
        }
    }
}

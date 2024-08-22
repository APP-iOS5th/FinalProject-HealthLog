//
//  ExerciseViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import UIKit

class ExercisesViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let containerStackView = UIStackView()
    private let searchOptionStackView = SearchBodyPartStackView()
    
    private let addButton = UIButton(type: .custom)
    private let dividerView = UIView()
    private let tableView = UITableView()
    
    let testView = UIView()
    var stackViewHeight: CGFloat?
    var stackViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupSearchController()
        setupSearchOptionStackView()
        setupDivider()
        setupTableView()
        setupBindings()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        title = "운동 목록"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // MARK: addButton
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "+"
        buttonConfig.baseBackgroundColor = .colorAccent
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .fixed
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 8, bottom: 2, trailing: 8)
        addButton.configuration = buttonConfig
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: tempStepperButton
        
        let tempStepperButton = UIBarButtonItem(title: "Stepper", style: .plain, target: self, action: #selector(tempStepperButtonTapped))
        self.navigationItem.leftBarButtonItem = tempStepperButton
    }
    
    private func setupSearchController() {

        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        let searchBar = searchController.searchBar
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black

        let placeHolder = NSAttributedString(
            string: "운동명 입력",
            attributes: [NSAttributedString.Key.foregroundColor:
                            UIColor.lightGray]
        )
        searchBar.searchTextField.attributedPlaceholder = placeHolder
        searchBar.searchTextField.textColor = .white
        
        definesPresentationContext = true
        
        // KVO. 오래된 방식이라 조금 위험?
        searchBar.setValue("닫기", forKey: "cancelButtonText")
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        let bookmarkIconImage = UIImage(systemName: "menubar.arrow.up.rectangle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        searchBar.setImage(bookmarkIconImage, for: .bookmark, state: .normal)
        let searchIconImage = UIImage(systemName: "text.magnifyingglass")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        searchBar.setImage(searchIconImage, for: .search, state: .normal)
//        searchBar.setImage(UIImage(systemName: "arrow.up"), for: .resultsList, state: .normal)
//        searchBar.setImage(UIImage(systemName: "arrow.down"), for: .clear, state: .normal)
    }
    
    private func setupSearchOptionStackView() {
        view.addSubview(searchOptionStackView)
        searchOptionStackView.translatesAutoresizingMaskIntoConstraints = false
        searchOptionStackView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchOptionStackView.stackContentHidden(isHidden: true)
    }
    
    func setupDivider() {
        dividerView.backgroundColor = .color252525
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: searchOptionStackView.bottomAnchor),
            dividerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1)
        ])
    }
    
    func setupTableView() {
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseListCell.self, forCellReuseIdentifier: "ExerciseCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBindings() {
        // MARK: Search Exercises Reload
        viewModel.$filteredExercises
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                print("tableView - reload")
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
        // MARK: SearchBodyPartOption Select
        searchOptionStackView
            .bodyPartOptionPublisher
            .sink { bodyPartOption in
                print("bodyPartOptionPublisher - \(bodyPartOption)")
                self.viewModel.selectedOption = bodyPartOption
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UISearchControllerDelegate
    
//    func willPresentSearchController(_ searchController: UISearchController) {
//        print("Search Controller will become active")
//        animateBodyPartsHidden(isHidden: false)
//    }
    
//    func willDismissSearchController(_ searchController: UISearchController) {
//        print("Search Controller will be dismissed")
//        animateBodyPartsHidden(isHidden: true)
//        searchOptionStackView.bodypartButtonList.first(where: { $0.bodypartOption == .all })?.sendActions(for: .touchUpInside)
//    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.setSearchText(to: searchText)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView Count - \(viewModel.filteredExercises.count)")
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseListCell
        
        let exercise = viewModel.filteredExercises[indexPath.row]
        cell.configure(with: exercise)
        cell.configurePushDetailViewButton(with: exercise, navigationController: self.navigationController!)
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    
    // MARK: - UISearchbarDelegatre
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar was touched and began editing.")
        animateBodyPartsHidden(isHidden: false)
    }
    
    // 북마크 버튼 클릭 시 동작
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Bookmark button clicked")
        searchBar.resignFirstResponder()
        animateBodyPartsHidden(isHidden: true)
    }
    
    // 입력시 동작
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            print("input - isEmpty")
        } else {
            print("input - not isEmpty")
        }
    }
    
    // 검색 버튼 클릭 시 동작
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked")
    }
    
    // 검색 결과 목록 버튼 클릭 시 동작
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("Results List button clicked")
    }
    
    // 취소버튼 메서드
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBar CancelButton Clicked")
        searchBar.resignFirstResponder()
        animateBodyPartsHidden(isHidden: true)
        searchOptionStackView.bodypartButtonList.first(where: { $0.bodypartOption == .all })?.sendActions(for: .touchUpInside)
    }
    
    // MARK: Methods
    
    @objc func addButtonTapped() {
        print("addButtonTapped!")
        let vc = ExercisesAddViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func tempStepperButtonTapped() {
        print("tempButtonTapped!")
        let vc = TempViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func customCancelButtonTapped() {}
    
    private func animateBodyPartsHidden(isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.searchOptionStackView.stackContentHidden(isHidden: isHidden)
        }
    }
}

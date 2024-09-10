//
//  ExerciseViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import Combine
import UIKit

class ExercisesViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    private let calculateViewModel = ExerciseCalculateViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchOptionStackView = SearchBodyPartStackView()
    private let dividerView = UIView()
    private let tableView = UITableView()
    
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
        view.backgroundColor = .color1E1E1E
        
        setupMain()
        setupSearchController()
        setupSearchOptionStackView()
        setupDivider()
        setupTableView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup
    
    func setupMain() {
        title = "운동리스트"
        self.navigationController?.setupBarAppearance()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let backbarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbarButtonItem
        
        // MARK: addButton
        let addButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .small)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        addButton.setImage(plusImage, for: .normal)
        addButton.backgroundColor = .colorAccent
        addButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        // MARK: handleTapOutsideSearchArea
        // 검색바 및 운동부위 옵션 영역의 바깥을 터치시, 운동부위옵션 및 키보드 접기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSearchArea))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true // 북마크 버튼
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        let placeHolder = NSAttributedString(string: "운동 검색", attributes: attributes)
        searchBar.searchTextField.attributedPlaceholder = placeHolder
        searchBar.searchTextField.textColor = .white
        
        definesPresentationContext = true
    }
    
    private func setupSearchOptionStackView() {
        view.addSubview(searchOptionStackView)
        searchOptionStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchOptionStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchOptionStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 13),
            searchOptionStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -13),
        ])
    }
    
    func setupDivider() {
        dividerView.backgroundColor = .colorSecondary
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(
                equalTo: searchOptionStackView.bottomAnchor),
            dividerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16),
            dividerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1)
        ])
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .color1E1E1E
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExerciseListCell.self,
                           forCellReuseIdentifier: "ExerciseCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dividerView.bottomAnchor,
                                          constant: 13),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupBindings() {
        // MARK: Search Exercises Reload
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
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.setSearchText(to: searchText)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("tableView Count - \(viewModel.filteredExercises.count)")
        return viewModel.filteredExercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseListCell
        
        let exercise = viewModel.filteredExercises[indexPath.row]
        cell.configure(with: exercise)
//        cell.configurePushDetailViewButton(
//            with: exercise, viewModel: viewModel,
//            navigationController: self.navigationController!)
        cell.selectionStyle = .none
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise = viewModel.filteredExercises[indexPath.row]
        let detailViewModel = ExerciseDetailViewModel(
            exercise: exercise, viewModel: viewModel)
        let vc = ExercisesDetailViewController(
            detailViewModel: detailViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    // 검색바 터치 및 검색 활성화
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar was touched and began editing.")
        if !viewModel.bodypartOptionShow {
            viewModel.bodypartOptionShow = true
        }
    }
    
    // 취소 버튼 터치
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBar CancelButton Clicked")
        if viewModel.bodypartOptionShow {
            viewModel.bodypartOptionShow = false
        }
        resetBodyPartsOption()
    }
    
    // 북마크 버튼(검색바 우측 끝) 터치
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Bookmark button clicked")
        viewModel.bodypartOptionShow.toggle()
    }
    
    // MARK: Selector Methods
    
    @objc private func addButtonTapped() {
        print("addButtonTapped!")
        let entryViewModel = ExerciseEntryViewModel(
            mode: .add, viewModel: viewModel)
        let vc = ExercisesEntryViewController(entryViewModel: entryViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func tempStepperButtonTapped() {
        print("tempButtonTapped!")
        let vc = TempViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func handleTapOutsideSearchArea(_ sender: UITapGestureRecognizer) {
        let isTappedInsideStackView = searchOptionStackView.frame.contains(sender.location(in: view))
        let isTappedInsideSearchBar = searchController.searchBar.frame.contains(sender.location(in: view))
        
        // 검색옵션스택뷰와 검색바 이외의 영역을 터치한 경우
        if !(isTappedInsideStackView || isTappedInsideSearchBar)  {
            print("Tap detected outside search area")
            if viewModel.bodypartOptionShow {
                viewModel.bodypartOptionShow = false
            }
        }
    }
    
    // MARK: - Methods
    
    // 스택뷰 안에 있는 Row들을 감추고 보여주는 애니메이션 (스택뷰 높이 자동 조절)
    private func animateBodyPartsHidden(isHidden: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.searchOptionStackView.stackContentHidden(isHidden: isHidden)
        }
    }
    
    // .all 버튼의 터치를 동작시켜서 옵션 초기화
    private func resetBodyPartsOption() {
        searchOptionStackView.bodypartButtonList
            .first(where: { $0.bodypartOption == .all })?
            .sendActions(for: .touchUpInside)
    }
    
    // Combine 용 운동부위옵션 접고 피는 함수
    private func bodypartOptionShowUIChange(_ bodypartOptionShow: Bool) {
        let iconName: String
        let searchBar = self.searchController.searchBar
        
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
}

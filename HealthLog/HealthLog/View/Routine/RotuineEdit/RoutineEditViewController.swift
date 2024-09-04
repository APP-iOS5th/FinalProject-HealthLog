//
//  RoutineEditViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/29/24.
//

import UIKit
import RealmSwift
import Combine

class RoutineEditViewController: UIViewController, SerchResultDelegate {
    
    let viewModel = RoutineEditViewModel()
    let index: Int
    let id: ObjectId
    private var cancellables = Set<AnyCancellable>()
    
    init(routineViewModel: RoutineViewModel, index: Int) {
        self.viewModel.getRoutine(routine: routineViewModel.routines[index])
        self.index = index
        self.id = routineViewModel.routines[index].id
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var resultsViewController = RoutineSearchResultsViewController()
    
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴 이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameVaildLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.font(.pretendardRegular, ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.isHidden = viewModel.isValid
        return label
    }()
    
    private lazy var exerciseTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴 운동"
        label.font = UIFont.font(.pretendardBold, ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .color2F2F2F
        // 더 좋은 방법 있으면 수정
        textField.attributedPlaceholder = NSAttributedString(string: "루틴 이름 입력", attributes: [NSAttributedString.Key.foregroundColor :  UIColor.systemGray])
        textField.textColor = .white
        textField.font = UIFont.font(.pretendardRegular, ofSize: 14)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.text = viewModel.routine.name
        return textField
        
    }()
    
    private lazy var rightBarButtonItem : UIBarButtonItem = {
        let rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        rightBarButtonItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "Pretendard-Semibold", size: 16) as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .normal)
        return rightBarButtonItem
    }()
    
    
    private lazy var searchController: UISearchController = {
        resultsViewController.delegate = self
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchResultsUpdater = self
        searchController.showsSearchResultsController = true
        return searchController
    }()
    
    // MARK: CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .color1E1E1E
        
        
        return collectionView
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupObservers()
    }
    
    func setupObservers() {
        nameTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.editNameTextField, on: viewModel)
            .store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.isRoutineNameEmptyPulisher, viewModel.isRoutineNameMatchingPulisher)
            .map { !$0 && !$1 }
            .print("유효성 검사")
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.nameVaildLabel.isHidden = isValid
            }
            .store(in: &cancellables)
        
        viewModel.isRoutineNameEmptyPulisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                if isValid {
                    self?.nameVaildLabel.text = "이름이 비어 있습니다."
                } else {
                    self?.nameVaildLabel.text = ""
                }
            }
            .store(in: &cancellables)

        
    }
    
    func setupUI() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "수정하기"
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.view.backgroundColor = .color1E1E1E
        tabBarController?.tabBar.isHidden = true
        
        
        //MARK: - addSubview
        
        
        
        
        self.view.addSubview(nameTitleLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(exerciseTitleLabel)
        self.view.addSubview(dividerView)
        self.view.addSubview(nameVaildLabel)
        
        
        
        
        let padding: CGFloat = 24
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            
            self.nameTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.nameTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            self.nameTextField.topAnchor.constraint(equalTo: self.nameTitleLabel.bottomAnchor, constant: 13),
            self.nameTextField.leadingAnchor.constraint(equalTo: self.nameTitleLabel.leadingAnchor),
            self.nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            self.nameVaildLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 5),
            self.nameVaildLabel.leadingAnchor.constraint(equalTo: self.nameTextField.leadingAnchor),
            
            self.exerciseTitleLabel.topAnchor.constraint(equalTo: self.nameVaildLabel.bottomAnchor, constant: 20),
            self.exerciseTitleLabel.leadingAnchor.constraint(equalTo: self.nameTitleLabel.leadingAnchor),
            
            self.dividerView.topAnchor.constraint(equalTo: self.exerciseTitleLabel.bottomAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: self.nameTitleLabel.leadingAnchor),
            self.dividerView.trailingAnchor.constraint(equalTo: self.nameTextField.trailingAnchor),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            
            
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(SetCell.self, forCellWithReuseIdentifier: SetCell.identifier)
        collectionView.register(SetCountHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SetCountHeaderView.identifier)
        collectionView.register(SetDividerFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SetDividerFooterView.identifier)
        
        collectionView.register(DeleteButtonCollectionViewCell.self,forCellWithReuseIdentifier: DeleteButtonCollectionViewCell.identifier)
        self.view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor, constant: 14),
            collectionView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor),
            
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    func didSelectItem(_ item: Exercise) {
        let routineExerciseSets: [RoutineExerciseSet] = (1...4).map { index in
            RoutineExerciseSet(order: index, weight: 0, reps: 0)
        }
        viewModel.routine.exercises.append(RoutineExercise(exercise: item, sets: routineExerciseSets))
        
        self.collectionView.reloadData()
        //        print("RoutinAddView: \(routineViewModel.routine.exercises.count)")
    }
    
    @objc func doneTapped() {
        if let text = nameTextField.text {
            viewModel.routine.name = text
        }
        viewModel.updateRoutine(routine: viewModel.routine, index: index)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}

// MARK: CollectionView

extension RoutineEditViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(viewModel.routine.exercises.count)
        return viewModel.routine.exercises.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == viewModel.routine.exercises.count {
            
            return 1
        }
        
        
        return viewModel.routine.exercises[section].sets.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.section)
        
        if indexPath.section == viewModel.routine.exercises.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteButtonCollectionViewCell.identifier, for: indexPath) as! DeleteButtonCollectionViewCell
            cell.delete = {
                self.viewModel.deleteRoutine(id: self.id)
                self.navigationController?.popToRootViewController(animated: true)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetCell.identifier, for: indexPath) as! SetCell
        cell.configure(with: viewModel.routine.exercises[indexPath.section].sets[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == viewModel.routine.exercises.count {
            return CGSize()
        }
        return CGSize(width: collectionView.bounds.width, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == viewModel.routine.exercises.count {
            return CGSize()
        }
        return CGSize(width: collectionView.bounds.width, height: 14)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == viewModel.routine.exercises.count {
            return  CGSize(width: collectionView.bounds.width, height: 44)
        }
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section != viewModel.routine.exercises.count {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetDividerFooterView.identifier, for: indexPath) as! SetDividerFooterView
                return footer
            }
            
            if kind == UICollectionView.elementKindSectionHeader {  // 섹션 헤더에 대한 처리 추가
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetCountHeaderView.identifier, for: indexPath) as! SetCountHeaderView
                header.configure(with: viewModel.routine.exercises[indexPath.section])
                
                header.setCountDidChange = { [weak self] newSetCount in
                    self?.viewModel.updateExerciseSetCount(for: indexPath.section, setCount: newSetCount)
                    self?.collectionView.reloadSections(IndexSet(integer: indexPath.section))
                }
                
                header.setDelete = {
                    self.viewModel.deleteExercise(for: indexPath.section)
                    self.collectionView.reloadData()
                }
                return header
            }
        }
        
        // 기본값으로 빈 UICollectionReusableView 반환 (예외 처리)
        return UICollectionReusableView()
    }
    
    
}

extension RoutineEditViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        
        if let resultcontroller = searchController.searchResultsController as? RoutineSearchResultsViewController {
            resultcontroller.viewModel.filterExercises(by: text)
            resultcontroller.tableView.reloadData()
        }
    }
}

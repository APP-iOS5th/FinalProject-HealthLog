//
//  RoutineEditViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/29/24.
//

import UIKit

class RoutineEditViewController: UIViewController, SerchResultDelegate {
    
    let routineViewModel = RoutineEditViewModel()
    let index: Int
    
    
    init(routineViewModel: RoutineViewModel, index: Int) {
        self.routineViewModel.getRoutine(routine: routineViewModel.routines[index])
        self.index = index
        
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
        textField.text = routineViewModel.routine.name
        return textField
        
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
    }
    
    func setupUI() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "수정하기"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.view.backgroundColor = .color1E1E1E
        tabBarController?.tabBar.isHidden = true
        
        
        //MARK: - addSubview
        
        
        
        
        self.view.addSubview(nameTitleLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(exerciseTitleLabel)
        self.view.addSubview(dividerView)
        
        
        
        
        let padding: CGFloat = 24
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            
            self.nameTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.nameTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            
            self.nameTextField.topAnchor.constraint(equalTo: self.nameTitleLabel.bottomAnchor, constant: 13),
            self.nameTextField.leadingAnchor.constraint(equalTo: self.nameTitleLabel.leadingAnchor),
            self.nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            self.exerciseTitleLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 26),
            self.exerciseTitleLabel.leadingAnchor.constraint(equalTo: self.nameTitleLabel.leadingAnchor),
            
            self.dividerView.topAnchor.constraint(equalTo: self.exerciseTitleLabel.bottomAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: self.nameTitleLabel.leadingAnchor),
            self.dividerView.trailingAnchor.constraint(equalTo: self.nameTextField.trailingAnchor),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            
            
        ])
        
    }
    
    func didSelectItem(_ item: Exercise) {
        let routineExerciseSets: [RoutineExerciseSet] = (1...4).map { index in
            RoutineExerciseSet(order: index, weight: 0, reps: 0)
        }
        routineViewModel.routine.exercises.append(RoutineExercise(exercise: item, sets: routineExerciseSets))
        
        self.collectionView.reloadData()
        //        print("RoutinAddView: \(routineViewModel.routine.exercises.count)")
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
            collectionView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -20),
            
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    
}


// MARK: CollectionView

extension RoutineEditViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(routineViewModel.routine.exercises.count)
        return routineViewModel.routine.exercises.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == routineViewModel.routine.exercises.count {
            
            return 1
        }
        
        
        return routineViewModel.routine.exercises[section].sets.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.section)
        
        if indexPath.section == routineViewModel.routine.exercises.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteButtonCollectionViewCell.identifier, for: indexPath) as! DeleteButtonCollectionViewCell
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetCell.identifier, for: indexPath) as! SetCell
        cell.configure(with: routineViewModel.routine.exercises[indexPath.section].sets[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == routineViewModel.routine.exercises.count {
            return CGSize()
        }
        return CGSize(width: collectionView.bounds.width, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == routineViewModel.routine.exercises.count {
            return CGSize()
        }
        return CGSize(width: collectionView.bounds.width, height: 14)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == routineViewModel.routine.exercises.count {
            return  CGSize(width: collectionView.bounds.width, height: 44)
        }
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section != routineViewModel.routine.exercises.count {
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetDividerFooterView.identifier, for: indexPath) as! SetDividerFooterView
                return footer
            }
            
            if kind == UICollectionView.elementKindSectionHeader {  // 섹션 헤더에 대한 처리 추가
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SetCountHeaderView.identifier, for: indexPath) as! SetCountHeaderView
                header.configure(with: routineViewModel.routine.exercises[indexPath.section])
                
                header.setCountDidChange = { [weak self] newSetCount in
                    self?.routineViewModel.updateExerciseSetCount(for: indexPath.section, setCount: newSetCount)
                    self?.collectionView.reloadSections(IndexSet(integer: indexPath.section))
                }
                
                header.setDelete = {
                    self.routineViewModel.deleteExercise(for: indexPath.section)
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

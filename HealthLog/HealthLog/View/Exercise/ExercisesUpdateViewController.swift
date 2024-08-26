//
//  ExercisesUpdateViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/17/24.
//

import Combine
import UIKit

class ExercisesUpdateViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    private let detailViewModel: ExerciseDetailViewModel
    
    private let deleteButton = UIButton(type: .system)
    
    // MARK: - Init
    
    init(detailViewModel: ExerciseDetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .color1E1E1E
        
        setupNavigationBar()
        setupDeleteButton()
        setupBindings()
    }
    
    func setupNavigationBar() {
        title = "운동 수정"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(
            title: "완료", style: .done, target: self,
            action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        
    }
    
    func setupDeleteButton() {
        deleteButton.backgroundColor = .color2F2F2F
        deleteButton.tintColor = .red
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.addTarget(
            self, action: #selector(deleteButtonTapped),
            for: .touchUpInside)
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupBindings() {
        
    }
    
    // MARK: - Methods
    
    @objc func doneButtonTapped() {
        print("doneButtonTapped!")
//        viewModel.realmWriteExercise()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonTapped() {
        print("deleteButtonTapped!")
        detailViewModel.realmExerciseIsDeleted()
        navigationController?.popToRootViewController(animated: true)
    }
}

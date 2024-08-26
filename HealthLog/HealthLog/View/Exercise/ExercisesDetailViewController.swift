//
//  ExerciseDetailViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/22/24.
//

import Combine
import UIKit

class ExercisesDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let detailViewModel: ExerciseDetailViewModel
    
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
        setupBindings()
    }
    
    func setupNavigationBar() {
        title = detailViewModel.exercise.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let editPushButton = UIBarButtonItem(
            title: "수정", style: .plain, target: self,
            action: #selector(editPushButtonTapped))
        editPushButton.isEnabled = detailViewModel.exercise.isCustom
        self.navigationItem.rightBarButtonItem = editPushButton
    }
    
    func setupBindings() {
        detailViewModel.$exercise
            .sink { exercise in
                self.title = exercise.name
            }
            .store(in: &cancellables)
    }
    
    @objc func editPushButtonTapped() {
        print("editPushButtonTapped!")
        let entryViewModel = ExerciseEntryViewModel(
            mode: .update(detailViewModel), viewModel: detailViewModel.viewModel)
        let vc = ExercisesEntryViewController(entryViewModel: entryViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

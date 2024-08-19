//
//  EditExerciseViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/19/24.
//

import UIKit

class EditExerciseViewController: UIViewController {
    private let scheduleExercise: ScheduleExercise
    
    lazy var nameLabel: UILabel  = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var setCountContainer: UIView = {
        let customStepper = TempViewController()
        guard let stepperView = customStepper.view else { return UIView() }
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        return stepperView
    }()
    
    init(scheduleExercise: ScheduleExercise) {
        self.scheduleExercise = scheduleExercise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = scheduleExercise.exercise?.name
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveEdit))
        
        view.addSubview(nameLabel)
        view.addSubview(setCountContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            setCountContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            setCountContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setCountContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc private func cancelEdit() {
        dismiss(animated: true)
    }
    
    @objc private func saveEdit() {
        dismiss(animated: true)
    }
}

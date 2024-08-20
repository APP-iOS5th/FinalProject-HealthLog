//
//  EditExerciseViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/19/24.
//

import UIKit

class EditExerciseViewController: UIViewController {
    private let scheduleExercise: ScheduleExercise
    
    init(scheduleExercise: ScheduleExercise) {
        self.scheduleExercise = scheduleExercise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    lazy var setsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = scheduleExercise.exercise?.name
        
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveEdit))
        
        view.addSubview(nameLabel)
        view.addSubview(setCountContainer)
        view.addSubview(setsContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            setCountContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            setCountContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setCountContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            setsContainer.topAnchor.constraint(equalTo: setCountContainer.bottomAnchor, constant: 10),
            setsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            setsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            setsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        
        print("ScheduleExercise: \(scheduleExercise)")
        for set in scheduleExercise.sets {
            let setView = createSetView(set: set)
            setsContainer.addArrangedSubview(setView)
        }
    }
    
    private func createSetView(set: ScheduleExerciseSet) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let setNumber = UILabel()
        setNumber.text = "\(set.order) 세트"
        setNumber.textColor = .white
        
        let weightLabel = UILabel()
        weightLabel.text = "\(set.weight) kg"
        weightLabel.textColor = .white
        
        let repsLabel = UILabel()
        repsLabel.text = "\(set.reps) 회"
        repsLabel.textColor = .white
        
        [setNumber, weightLabel, repsLabel].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        let stackView = UIStackView(arrangedSubviews: [
            setNumber, weightLabel, repsLabel
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            view.heightAnchor.constraint(equalToConstant: 50),
        ])

        return view
    }
    @objc private func cancelEdit() {
        dismiss(animated: true)
    }
    
    @objc private func saveEdit() {
        dismiss(animated: true)
    }
}

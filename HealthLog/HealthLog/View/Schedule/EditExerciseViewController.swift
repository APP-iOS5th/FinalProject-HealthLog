//
//  EditExerciseViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/19/24.
//

import UIKit

class EditExerciseViewController: UIViewController, UITextFieldDelegate {
    private let scheduleExercise: ScheduleExercise
    private var stepperValue = 0
    
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
    
    lazy var stepperLabel: UILabel = {
        let label = UILabel()
        label.text = "세트 수"
        label.textColor = .white
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stepperCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(stepperValue)"
        label.textColor = .white
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = 0
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.layer.cornerRadius = 8
        stepper.backgroundColor = .colorAccent
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        // customize stepper style
        let config = UIImage.SymbolConfiguration(scale: .medium)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        let minusImage = UIImage(systemName: "minus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        stepper.setIncrementImage(plusImage, for: .normal)
        stepper.setDecrementImage(minusImage, for: .normal)
        
        return stepper
    }()
    
    lazy var stepperContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var setsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = scheduleExercise.exercise?.name
        stepperValue = scheduleExercise.sets.count
        setupUI()
    }
    
    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveEdit))
        
        stepperContainer.addSubview(stepperLabel)
        stepperContainer.addSubview(stepperCountLabel)
        stepperContainer.addSubview(stepper)
        
        view.addSubview(nameLabel)
        view.addSubview(stepperContainer)
        view.addSubview(setsContainer)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            stepperContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            stepperContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stepperContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stepperContainer.heightAnchor.constraint(equalToConstant: 44),
            
            stepperLabel.leadingAnchor.constraint(equalTo: stepperContainer.leadingAnchor, constant: 16),
            stepperLabel.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            stepperCountLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -20),
            stepperCountLabel.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: stepperContainer.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            setsContainer.topAnchor.constraint(equalTo: stepperContainer.bottomAnchor, constant: 10),
            setsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        print("ScheduleExercise: \(scheduleExercise)")
        
        for set in scheduleExercise.sets {
            let setView = createSetView(set)
            setsContainer.addArrangedSubview(setView)
        }
    }
    
    private func updateSets() {
        
    }
    
    private func createSetView(_ set: ScheduleExerciseSet?) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let setNumber = UILabel()
        setNumber.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setNumber.textColor = .white
        setNumber.translatesAutoresizingMaskIntoConstraints = false
        
        let weightTextField = UITextField()
        weightTextField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightTextField.textColor = .white
        weightTextField.textAlignment = .center
        weightTextField.keyboardType = .numberPad
        weightTextField.backgroundColor = .colorSecondary
        weightTextField.layer.cornerRadius = 10
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        
        weightTextField.attributedPlaceholder = NSAttributedString(
            string: "무게",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                NSAttributedString.Key.font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        let weightLabel = UILabel()
        weightLabel.text = "kg"
        weightLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightLabel.textColor = .white
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let repsTextField = UITextField()
        repsTextField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsTextField.textColor = .white
        repsTextField.textAlignment = .center
        repsTextField.keyboardType = .numberPad
        repsTextField.backgroundColor = .colorSecondary
        repsTextField.layer.cornerRadius = 10
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        
        repsTextField.attributedPlaceholder = NSAttributedString(
            string: "횟수",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                NSAttributedString.Key.font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        let repsLabel = UILabel()
        repsLabel.text = "회"
        repsLabel.textColor = .white
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let set = set {
            setNumber.text = "\(set.order) 세트"
            weightTextField.text = "\(set.weight)"
            repsTextField.text = "\(set.reps)"
        } else {
            setNumber.text = " 세트"
            weightTextField.text = ""
            repsTextField.text = ""
        }
        
        [setNumber, weightTextField, weightLabel, repsTextField, repsLabel].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        
        view.addSubview(setNumber)
        view.addSubview(weightTextField)
        view.addSubview(weightLabel)
        view.addSubview(repsTextField)
        view.addSubview(repsLabel)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 35),
            
            setNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setNumber.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            weightTextField.leadingAnchor.constraint(equalTo: setNumber.trailingAnchor, constant: 45),
            weightTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 58),
            weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            weightLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            repsTextField.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 38),
            repsTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 58),
            repsTextField.heightAnchor.constraint(equalToConstant: 35),
            
            repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 8),
            repsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        return view
    }
    @objc private func cancelEdit() {
        dismiss(animated: true)
    }
    
    @objc private func saveEdit() {
        dismiss(animated: true)
    }
    
    @objc func stepperValueChanged() {
        
        updateSets()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 3
    }
}

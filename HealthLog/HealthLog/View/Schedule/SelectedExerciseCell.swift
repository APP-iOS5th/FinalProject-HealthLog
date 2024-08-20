//
//  SelectedExerciseCell.swift
//  HealthLog
//
//  Created by seokyung on 8/13/24.
//

import UIKit

class SelectedExerciseCell: UITableViewCell, UITextFieldDelegate {
    
    var exerciseTitleLabel = UILabel()
    var deleteButton = UIButton(type: .system)
    
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    var deleteButtonTapped: (() -> Void)?
    var heightDidChange: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .colorPrimary
        
        exerciseTitleLabel.font = UIFont(name: "Pretendard-Semibold", size: 18)
        exerciseTitleLabel.textColor = .white
        exerciseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exerciseTitleLabel)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        // 컨테이너 뷰 설정
        containerView.backgroundColor = .colorSecondary
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        setupStepperComponents()
        
        NSLayoutConstraint.activate([
            exerciseTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            exerciseTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            exerciseTitleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            
            deleteButton.centerYAnchor.constraint(equalTo: exerciseTitleLabel.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 14),
            deleteButton.heightAnchor.constraint(equalToConstant: 14),
            
            containerView.topAnchor.constraint(equalTo: exerciseTitleLabel.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func setupStepperComponents() {
        let stepperLabel = UILabel()
        stepperLabel.text = "세트 수"
        stepperLabel.textColor = .white
        stepperLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stepperCountLabel = UILabel()
        stepperCountLabel.text = "4"
        stepperCountLabel.textColor = .white
        stepperCountLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        stepperCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.value = 4
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.layer.cornerRadius = 8
        stepper.backgroundColor = .colorAccent
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        // Stepper의 + 와 - 버튼의 색상 변경
        let config = UIImage.SymbolConfiguration(scale: .medium)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        let minusImage = UIImage(systemName: "minus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        stepper.setIncrementImage(plusImage, for: .normal)
        stepper.setDecrementImage(minusImage, for: .normal)
        
        containerView.addSubview(stepperLabel)
        containerView.addSubview(stepperCountLabel)
        containerView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            stepperLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stepperLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stepperCountLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -20),
            stepperCountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        updateSetInputs(for: Int(stepper.value))
    }
    
    @objc func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
        if let stepperCountLabel = sender.superview?.subviews.compactMap({ $0 as? UILabel }).last {
            stepperCountLabel.text = "\(value)"
        }
        updateSetInputs(for: value)
        heightDidChange?()
    }
    
    func updateSetInputs(for count: Int) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...count {
            let setView = createSetInputView(setNumber: i)
            stackView.addArrangedSubview(setView)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func createSetInputView(setNumber: Int) -> UIView {
        let setView = UIView()
        
        let setLabel = UILabel()
        setLabel.text = "\(setNumber) 세트"
        setLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setLabel.textColor = .white
        
        let weightTextField = UITextField()
        weightTextField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightTextField.textColor = .white
        weightTextField.textAlignment = .center
        weightTextField.keyboardType = .numberPad
        weightTextField.backgroundColor = .colorSecondary
        weightTextField.layer.cornerRadius = 10
        weightTextField.attributedPlaceholder = NSAttributedString(
            string: "무게",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        let weightLabel = UILabel()
        weightLabel.text = "kg"
        weightLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightLabel.textColor = .white
        
        let repsTextField = UITextField()
        repsTextField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsTextField.textColor = .white
        repsTextField.textAlignment = .center
        repsTextField.keyboardType = .numberPad
        repsTextField.backgroundColor = .colorSecondary
        repsTextField.layer.cornerRadius = 10
        repsTextField.attributedPlaceholder = NSAttributedString(
            string: "횟수",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        let repsLabel = UILabel()
        repsLabel.text = "회"
        repsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsLabel.textColor = .white
        
        setView.addSubview(setLabel)
        setView.addSubview(weightTextField)
        setView.addSubview(weightLabel)
        setView.addSubview(repsTextField)
        setView.addSubview(repsLabel)
        
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            setView.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            
            setLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 8),
            setLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: setLabel.trailingAnchor, constant: 45),
            weightTextField.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 58),
            weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            weightLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            weightLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            
            repsTextField.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 38),
            repsTextField.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 58),
            repsTextField.heightAnchor.constraint(equalToConstant: 35),
            
            repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 8),
            repsLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -8)
        ])
        
        return setView
    }
    
    @objc func deleteTapped() {
        deleteButtonTapped?()
    }
    
    func configure(with exerciseName: String) {
        exerciseTitleLabel.text = exerciseName
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 3
    }
}

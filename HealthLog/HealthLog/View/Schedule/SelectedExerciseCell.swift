//
//  SelectedExerciseCell.swift
//  HealthLog
//
//  Created by seokyung on 8/13/24.
//

import Combine
import UIKit

class SelectedExerciseCell: UITableViewCell, UITextFieldDelegate {
    var exerciseTitleLabel = UILabel()
    var deleteButton = UIButton(type: .system)
    let stepperLabel = UILabel()
    private let containerView = UIView()
    let stepperCountLabel = UILabel()
    let stackView = SetInputStackView()
    private var weightTextFields: [UITextField] = []
    private var repsTextFields: [UITextField] = []
    var deleteButtonTapped: (() -> Void)?
    var setCountDidChange: ((Int) -> Void)?
    var currentSetCount: Int = 4
    let stepper = UIStepper()
    var updateSet: ((Int, Int, Int) -> Void)?
    var exerciseIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.backgroundColor = .color1E1E1E
        
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
        
        stepperCountLabel.textColor = .white
        stepperCountLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        stepperCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepper.minimumValue = 1
        stepper.maximumValue = 10
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
    }
    
    // 스테퍼 값 변경 시 setCount 뷰모델에 전달
    @objc func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
        setCountDidChange?(value)
        
        // + - 버튼 클릭 출력용
        //        if value > currentSetCount {
        //            print("Stepper + button pressed : value - \(value), currentSetCount - \(currentSetCount)")
        //        } else if value < currentSetCount {
        //            print("Stepper - button pressed : value - \(value), -currentSetCount - \(currentSetCount)")
        //        }
    }
    
    @objc func deleteTapped() {
        deleteButtonTapped?()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 3 {
            return false
        }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet) == false {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldDidEndEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let setIndex = stackView.weightTextFields.firstIndex(of: textField) ?? stackView.repsTextFields.firstIndex(of: textField) ?? 0
        let weight = Int(stackView.weightTextFields[setIndex].text ?? "") ?? 0
        let reps = Int(stackView.repsTextFields[setIndex].text ?? "") ?? 0
        
        updateSet?(setIndex, weight, reps)
    }
    
    func configure(_ exercise: ScheduleExercise) {
        currentSetCount = exercise.sets.count // currentSetCount도 여기서 초기화
        
        exerciseTitleLabel.text = exercise.exercise?.name
        stepperCountLabel.text = String(currentSetCount)
        stepper.value = Double(currentSetCount)
        
        // stackView 초기화
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.weightTextFields.removeAll()
        stackView.repsTextFields.removeAll()
        
        // 데이터에 맞춰서 stackView 그리기
        (1...currentSetCount).forEach { setNumber in
            let setView = SetInputRowView(
                setNumber: setNumber,
                set: exercise.sets[setNumber - 1],
                delegate: self
            )
            stackView.addArrangedSubview(setView)
            stackView.appendTextFields(
                weightTextField: setView.weightTextField,
                repsTextField: setView.repsTextField)
        }
        
    }
}

class SetInputStackView: UIStackView {
    var weightTextFields: [UITextField] = []
    var repsTextFields: [UITextField] = []
    
    func appendTextFields(
        weightTextField: UITextField, repsTextField: UITextField) {
            self.weightTextFields.append(weightTextField)
            self.repsTextFields.append(repsTextField)
        }
}

class SetInputRowView: UIView {
    let setLabel = UILabel()
    let weightTextField = UITextField()
    let weightLabel = UILabel()
    let repsTextField = UITextField()
    let repsLabel = UILabel()
    
    init(setNumber: Int, set: ScheduleExerciseSet, delegate: SelectedExerciseCell) {
        super.init(frame: .zero)
        createSetInputView(setNumber: setNumber, set: set)
        inputDelegate(delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSetInputView(setNumber: Int, set: ScheduleExerciseSet) {
        // MARK: setLabel
        setLabel.text = "\(setNumber) 세트"
        setLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setLabel.textColor = .white
        
        // MARK: weightTextField
        weightTextField.text = set.weight == 0 ? "" : String(set.weight)
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
        
        // MARK: weightLabel
        weightLabel.text = "kg"
        weightLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightLabel.textColor = .white
        
        // MARK: repsTextField
        repsTextField.text = set.reps == 0 ? "" : String(set.reps)
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
        
        // MARK: repsLabel
        repsLabel.text = "회"
        repsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsLabel.textColor = .white
        
        
        // MARK: addSubview
        self.addSubview(setLabel)
        self.addSubview(weightTextField)
        self.addSubview(weightLabel)
        self.addSubview(repsTextField)
        self.addSubview(repsLabel)
        
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            
            setLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            setLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            weightTextField.trailingAnchor.constraint(equalTo: weightLabel.leadingAnchor, constant: -8),
            weightTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            weightTextField.topAnchor.constraint(equalTo: self.topAnchor),
            weightTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 58),
            
            weightLabel.trailingAnchor.constraint(equalTo: repsTextField.leadingAnchor, constant: -38),
            weightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            repsTextField.trailingAnchor.constraint(equalTo: repsLabel.leadingAnchor, constant: -8),
            repsTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repsTextField.topAnchor.constraint(equalTo: self.topAnchor),
            repsTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 58),
            
            repsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    func inputDelegate(delegate: SelectedExerciseCell) {
        weightTextField.delegate = delegate
        repsTextField.delegate = delegate
    }
}

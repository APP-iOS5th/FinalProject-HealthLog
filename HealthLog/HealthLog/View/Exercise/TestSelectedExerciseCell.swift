//
//  TestSelectedExerciseCell.swift
//  HealthLog
//
//  Created by user on 8/25/24.
//

import Combine
import UIKit

class TestSelectedExerciseCell: UITableViewCell, UITextFieldDelegate {
    var exerciseTitleLabel = UILabel()
    var deleteButton = UIButton(type: .system)
    let stepperLabel = UILabel()
    private let containerView = UIView()
    let stepperCountLabel = UILabel() // MARK: 영우 - containerView에서 프로퍼티로 이동해옴
    let stackView = SetInputStackView() // MARK: 영우 - private 삭제
    private var weightTextFields: [UITextField] = []
    private var repsTextFields: [UITextField] = []
    var deleteButtonTapped: (() -> Void)?
    var setsDidChange: ((_ sets: [ScheduleExerciseSetStruct]) -> Void)?
    var setCountDidChange: ((Int) -> Void)?
    var currentSetCount: Int = 4
    let stepper = UIStepper() // MARK: 영우 - private 삭제
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        
//         // MARK: Cell 프로퍼티로 이동
//        stepperCountLabel.text = "\(currentSetCount)"
        stepperCountLabel.textColor = .white
        stepperCountLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        stepperCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepper.minimumValue = 1
        stepper.maximumValue = 10
//        stepper.value = Double(currentSetCount)
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
    
    // MARK: 영우 - @Published currentSetCount에 stepper 변경값 넣기
    // 스테퍼 값 변경 시 setCount 뷰모델에 전달
    @objc func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
//        currentSetCount = value // MARK: 삭제
        setCountDidChange?(value)
        
        // + - 버튼 클릭 출력용
        if value > currentSetCount {
            print("Stepper + button pressed : value - \(value), currentSetCount - \(currentSetCount)")
        } else if value < currentSetCount {
            print("Stepper - button pressed : value - \(value), -currentSetCount - \(currentSetCount)")
        }


        
    }
    
    // 세트 수가 변경되면 스택뷰 내의 기존 세트 입력 필드를 제거하고, 새로운 세트 수에 맞게 다시 생성
    func updateSetInputs(for count: Int) {
        //print("\(exerciseTitleLabel.text ?? "Unknown exercise")의 세트 수: \(count)")
        //print("업데이트 전 weightTextFields count: \(weightTextFields.count), repsTextFields count: \(repsTextFields.count)")
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        weightTextFields.removeAll()
        repsTextFields.removeAll()
        
        // 세트 입력 뷰 세트 수만큼 생성해서 스택뷰에 addSubview
        
        // MARK: 영우
//        for i in 1...count {
//            let setView = createSetInputView(setNumber: i)
//            stackView.addArrangedSubview(setView)
//        }
        
        
        //print("업데이트 후 weightTextFields count: \(weightTextFields.count), repsTextFields count: \(repsTextFields.count)")
        
        // 세트가 변경될 때마다 클로저를 호출해 뷰모델에 알려주기(다른 곳에 구현하기!)
        //        if let setsDidChange = setsDidChange {
        //            let sets = createScheduleExerciseSets() // 세트 생성하고
        //            setsDidChange(sets) // ViewModel에 업데이트
        //        }
    }
    
    
    @objc func deleteTapped() {
        deleteButtonTapped?()
    }
    
//    func configure(with exerciseName: String, setCount: Int) {
//        exerciseTitleLabel.text = exerciseName
//        currentSetCount = setCount
//        stepper.value = Double(setCount)
//        if let stepperCountLabel = stepper.superview?.subviews.compactMap({ $0 as? UILabel }).last {
//            stepperCountLabel.text = "\(setCount)"
//        }
//        updateSetInputs(for: setCount)
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        let currentText = textField.text ?? ""
        //        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        //        if newText.count > 3 {
        //            return false
        //        }
        //        let allowedCharacters = CharacterSet.decimalDigits
        //        let characterSet = CharacterSet(charactersIn: string)
        //        if allowedCharacters.isSuperset(of: characterSet) == false {
        //            return false
        //        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.async {
            if let viewController = self.parentViewController as? AddScheduleViewController {
                viewController.validateCompletionButton()
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // 모든 텍스트 필드의 값 저장
        saveTextFieldValues()
    }
    
    func saveTextFieldValues() {
        if let setsDidChange = setsDidChange {
            let sets = createScheduleExerciseSets()
            setsDidChange(sets)
        }
    }
    
    func areAllFieldsFilled() -> Bool {
        return stackView.arrangedSubviews.allSatisfy { setView in
            setView.subviews.compactMap { $0 as? UITextField }.allSatisfy { !$0.text!.isEmpty }
        }
    }
    
    func createScheduleExerciseSets() -> [ScheduleExerciseSetStruct] {
        return (0..<weightTextFields.count).compactMap { index in
            guard let weightText = weightTextFields[index].text, let weight = Int(weightText),
                  let repsText = repsTextFields[index].text, let reps = Int(repsText) else {
                return nil
            }
            let set = ScheduleExerciseSetStruct(order: index, weight: weight, reps: reps, isCompleted: false)
            //print("Created set: \(set)")
            return set
        }
    }
    
    // MARK: 영우 - 데이터 set은 전부 여기서. 위에서 해주던 부분 삭제
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

// MARK: 영우 - stackView의 요소에 접근하기 편하게 Class화
class SetInputStackView: UIStackView {
    var weightTextFields: [UITextField] = []
    var repsTextFields: [UITextField] = []
    
    func appendTextFields(
        weightTextField: UITextField, repsTextField: UITextField) {
        self.weightTextFields.append(weightTextField)
        self.repsTextFields.append(repsTextField)
    }
}

// MARK: 영우 - setView의 요소에 접근하기 편하게 Class화
class SetInputRowView: UIView {
    let setLabel = UILabel()
    let weightTextField = UITextField()
    let weightLabel = UILabel()
    let repsTextField = UITextField()
    let repsLabel = UILabel()
    
    init(setNumber: Int, set: ScheduleExerciseSet, delegate: TestSelectedExerciseCell) {
        super.init(frame: .zero)
        createSetInputView(setNumber: setNumber, set: set)
        inputDelegate(delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 서경 - 각 세트에 대한 무게와 횟수 입력을 위한 뷰를 생성하는 메서드 [1세트 _kg _회]
    func createSetInputView(setNumber: Int, set: ScheduleExerciseSet) {
        // MARK: setLabel
        setLabel.text = "\(setNumber) 세트"
        setLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setLabel.textColor = .white
        
        // MARK: weightTextField
        weightTextField.text = String(set.weight) // MARK: 영우
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
        repsTextField.text = String(set.reps) // MARK: 영우
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
            weightTextField.leadingAnchor.constraint(equalTo: setLabel.trailingAnchor, constant: 45),
            weightTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 58),
            weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            weightLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            weightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            repsTextField.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 38),
            repsTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 58),
            repsTextField.heightAnchor.constraint(equalToConstant: 35),
            
            repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 8),
            repsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }
    
    func inputDelegate(delegate: TestSelectedExerciseCell) {
        weightTextField.delegate = delegate
        repsTextField.delegate = delegate
    }
}
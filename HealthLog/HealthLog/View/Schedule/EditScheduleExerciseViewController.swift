//
//  EditExerciseViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/19/24.
//

import UIKit
import RealmSwift
import Combine

protocol EditScheduleExerciseViewControllerDelegate: AnyObject {
    func didUpdateScheduleExercise()
}

class EditScheduleExerciseViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: EditScheduleExerciseViewControllerDelegate?
    
    private let viewModel = ScheduleViewModel()
    private let scheduleExercise: ScheduleExercise
    private let selectedDate: Date
    private var stepperValue = 0
    private var setValues: [(order: Int, weight: String, reps: String)] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(scheduleExercise: ScheduleExercise, selectedDate: Date) {
        self.scheduleExercise = scheduleExercise
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.isEnabled = false
        button.alpha = 0.4
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
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
        stepper.value = Double(stepperValue)
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
    
    lazy var scrollContainer: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "삭제"
        configuration.baseBackgroundColor = .colorSecondary
        configuration.baseForegroundColor = .red
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(didTapDeleteExercise), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = scheduleExercise.exercise?.name
        stepperValue = scheduleExercise.sets.count
        stepper.value = Double(stepperValue)
        
        // save scheduleExercies.sets to setValues
        setValues = scheduleExercise.sets.map { set in
            return (order: set.order, weight: "\(set.weight)", reps: "\(set.reps)")
        }
        
        setupUI()
        updateSets()
        bindViewModel()
        setupKeyboard()
        hideKeyBoardWhenTappedScreen()
    }
    
    private func bindViewModel() {
        viewModel.$isInputValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.completeButton.isEnabled = isValid
                self?.completeButton.alpha = isValid ? 1.0 : 0.5
            }
            .store(in: &cancellables)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        scrollContainer.keyboardDismissMode = .interactive
    }
    
    // MARK: - Methods
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollContainer.contentInset = contentInsets
        scrollContainer.scrollIndicatorInsets = contentInsets
        
        if let activeField = view.currentFirstResponder() as? UITextField {
            let activeRect = activeField.convert(activeField.bounds, to: scrollContainer)
            scrollContainer.scrollRectToVisible(activeRect, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollContainer.contentInset = contentInsets
        scrollContainer.scrollIndicatorInsets = contentInsets
    }
    
    func hideKeyBoardWhenTappedScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapHandler() {
        self.view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        stepperContainer.addSubview(stepperLabel)
        stepperContainer.addSubview(stepperCountLabel)
        stepperContainer.addSubview(stepper)
        scrollContainer.addSubview(setsContainer)
        
        view.addSubview(cancelButton)
        view.addSubview(completeButton)
        view.addSubview(nameLabel)
        view.addSubview(stepperContainer)
        view.addSubview(scrollContainer)
        view.addSubview(deleteButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nameLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 13),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            
            stepperContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            stepperContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            stepperContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            stepperContainer.heightAnchor.constraint(equalToConstant: 50),
            
            stepperLabel.leadingAnchor.constraint(equalTo: stepperContainer.leadingAnchor, constant: 16),
            stepperLabel.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            stepperCountLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -20),
            stepperCountLabel.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: stepperContainer.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: stepperContainer.bottomAnchor, constant: 10),
            scrollContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10),
            
            setsContainer.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            setsContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            setsContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            setsContainer.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -10),
            setsContainer.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        cancelButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(saveEdit), for: .touchUpInside)
    }
    
    private func updateSets() {
        // save inputs to setValues
        saveInputs()
        
        // trim setValues if stepperValue is less than setValues count
        if setValues.count > stepperValue {
            setValues = Array(setValues.prefix(stepperValue))
        }
        
        // reset setsContainer
        setsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // add sets
        for i in 0..<stepperValue {
            let set = i < setValues.count ? setValues[i] : nil
            let setView = createSetView(set)
            setsContainer.addArrangedSubview(setView)
            
            NSLayoutConstraint.activate([
                setView.leadingAnchor.constraint(equalTo: setsContainer.leadingAnchor, constant: 26),
                setView.trailingAnchor.constraint(equalTo: setsContainer.trailingAnchor, constant: -26)
            ])
        }
        
        stepperCountLabel.text = "\(stepperValue)"
    }
    
    private func saveInputs() {
        for (index, view) in setsContainer.arrangedSubviews.enumerated() {
            if let weightTextField = view.viewWithTag(1000) as? UITextField,
               let repsTextField = view.viewWithTag(1001) as? UITextField {
                let weight = weightTextField.text ?? ""
                let reps = repsTextField.text ?? ""
                if index < setValues.count {
                    setValues[index] = (order: index + 1, weight: weight, reps: reps)
                } else {
                    setValues.append((order: index + 1, weight: weight, reps: reps))
                }
            }
        }
    }
    
    private func createSetView(_ set: (order: Int, weight: String, reps: String)?) -> UIView {
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
        weightTextField.tag = 1000
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
        repsTextField.tag = 1001
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        
        repsTextField.attributedPlaceholder = NSAttributedString(
            string: "횟수",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                NSAttributedString.Key.font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        let repsLabel = UILabel()
        repsLabel.text = "회"
        repsLabel.textColor = .white
        repsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setNumber.text = "\(setsContainer.arrangedSubviews.count + 1) 세트"
        weightTextField.text = set?.weight
        repsTextField.text = set?.reps
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        weightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        repsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view.addSubview(setNumber)
        view.addSubview(weightTextField)
        view.addSubview(weightLabel)
        view.addSubview(repsTextField)
        view.addSubview(repsLabel)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 35),
            
            setNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            setNumber.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            weightTextField.trailingAnchor.constraint(equalTo: weightLabel.leadingAnchor, constant: -8),
            weightTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 58),
            weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            weightLabel.trailingAnchor.constraint(equalTo: repsTextField.leadingAnchor, constant: -38),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            repsTextField.trailingAnchor.constraint(equalTo: repsLabel.leadingAnchor, constant: -8),
            repsTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 58),
            repsTextField.heightAnchor.constraint(equalToConstant: 35),
            
            //repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 8),
            repsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        return view
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateViewModelSetValues()
    }
    
    private func updateViewModelSetValues() {
        let updatedSetValues = setsContainer.arrangedSubviews.enumerated().map { (index, view) -> (order: Int, weight: String, reps: String) in
            let weightTextField = view.viewWithTag(1000) as? UITextField
            let repsTextField = view.viewWithTag(1001) as? UITextField
            return (order: index + 1, weight: weightTextField?.text ?? "", reps: repsTextField?.text ?? "")
        }
        viewModel.updateSetValues(updatedSetValues)
    }
    
    @objc private func cancelEdit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveEdit() {
        saveInputs()
        viewModel.saveEditedExercise(scheduleExercise: scheduleExercise, setValues: setValues)
        delegate?.didUpdateScheduleExercise()
        
        let alertController = UIAlertController(title: "운동 수정 완료", message: "\(String(describing: scheduleExercise.exercise!.name))이(가) 성공적으로 수정되었습니다.", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true)
        }
    }
    
    @objc func stepperValueChanged() {
        stepperValue = Int(stepper.value)
        updateSets()
        updateViewModelSetValues()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.isEmpty || (newText.count <= 3 && Int(newText) != nil)
    }
    
    @objc func didTapDeleteExercise() {
        // alert to confirm delete
        let alertController = UIAlertController(
            title: "운동 삭제",
            message: "\(String(describing: scheduleExercise.exercise!.name))이(가) 삭제됩니다.",
            preferredStyle: .alert
        )
        
        // add confirm action
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            guard let self = self else { return } // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
            let exerciseName = self.scheduleExercise.exercise?.name ?? "운동"
            
            self.viewModel.deleteExercise(scheduleExercise: self.scheduleExercise, selectedDate: self.selectedDate)
            self.delegate?.didUpdateScheduleExercise()
            
            
            let alertCompletion = UIAlertController(title: "운동 수정 완료", message: "\(String(describing: exerciseName))이(가) 성공적으로 수정되었습니다.", preferredStyle: .alert)
            self.present(alertCompletion, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertCompletion.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true)
            }
        }
        
        // add cancel action
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // add actions to the alter controller
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//
//  EditExerciseViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/19/24.
//

import UIKit
import RealmSwift

protocol EditScheduleExerciseViewControllerDelegate: AnyObject {
    func didUpdateScheduleExercise()
}

class EditScheduleExerciseViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: EditScheduleExerciseViewControllerDelegate?
    
//    let realm = try! Realm()
    let realm = RealmManager.shared.realm
    
    private let scheduleExercise: ScheduleExercise
    private let selectedDate: Date
    private var stepperValue = 0
    private var setValues: [(order: Int, weight: String, reps: String)] = []
    
    init(scheduleExercise: ScheduleExercise, selectedDate: Date) {
        self.scheduleExercise = scheduleExercise
        self.selectedDate = selectedDate
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // add observer of keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // delete observer of keyboard notification
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        if let parentVC = self.parent {
            UIView.animate(withDuration: animationDuration) {
                parentVC.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        if let parentVC = self.parent {
            UIView.animate(withDuration: animationDuration) {
                parentVC.view.transform = .identity
            }
        }
    }
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveEdit))
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        stepperContainer.addSubview(stepperLabel)
        stepperContainer.addSubview(stepperCountLabel)
        stepperContainer.addSubview(stepper)
        scrollContainer.addSubview(setsContainer)
        
        view.addSubview(nameLabel)
        view.addSubview(stepperContainer)
        view.addSubview(scrollContainer)
        view.addSubview(deleteButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            
            stepperContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            stepperContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            stepperContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            stepperContainer.heightAnchor.constraint(equalToConstant: 44),
            
            stepperLabel.leadingAnchor.constraint(equalTo: stepperContainer.leadingAnchor, constant: 16),
            stepperLabel.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            stepperCountLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -20),
            stepperCountLabel.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: stepperContainer.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: stepperContainer.centerYAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: stepperContainer.bottomAnchor, constant: 10),
            scrollContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            scrollContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            scrollContainer.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10),
            
            setsContainer.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            setsContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            setsContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            setsContainer.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            setsContainer.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
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
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setNumber.text = "\(setsContainer.arrangedSubviews.count + 1) 세트"
        weightTextField.text = set?.weight
        repsTextField.text = set?.reps
        
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
        saveInputs()
        guard let realm = realm else {return} // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
        do {
            try realm.write {
                for i in 0..<setValues.count {
                    if i < scheduleExercise.sets.count {
                        scheduleExercise.sets[i].order = setValues[i].order
                        scheduleExercise.sets[i].weight = Int(setValues[i].weight) ?? 0
                        scheduleExercise.sets[i].reps = Int(setValues[i].reps) ?? 0
                    } else {
                        let set = ScheduleExerciseSet(
                            order: setValues[i].order,
                            weight: Int(setValues[i].weight) ?? 0,
                            reps: Int(setValues[i].reps) ?? 0,
                            isCompleted: false
                        )
                        scheduleExercise.sets.append(set)
                    }
                }
                
                if setValues.count < scheduleExercise.sets.count {
                    let scheduleExerciseSetsCount = scheduleExercise.sets.count
                    for j in (setValues.count..<scheduleExerciseSetsCount).reversed() {
                        realm.delete(scheduleExercise.sets[j])
                    }
                }
            }
            // notify the delegate of the update
            delegate?.didUpdateScheduleExercise()
        } catch {
            print("Error updating ScheduleExercise")
        }
        
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 3
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
            guard let self = self , let realm = realm else { return } // realm 에러처리를 위해 코드를 삽입했습니다 _ 허원열
            let exerciseName = self.scheduleExercise.exercise?.name ?? "운동"
            let selectedDate = self.selectedDate

            do {
                let schedule = realm.objects(Schedule.self).filter("date == %@", selectedDate).first // realm 에러처리를 위해 self를 뺐습니다.

                try realm.write {
                    guard let exercises = schedule?.exercises else { return }
                    if exercises.count > 1 {
                        realm.delete(self.scheduleExercise)
                    } else {
                        realm.delete(schedule!)
                    }
                }
                
                // notify the delegate of the update
                self.delegate?.didUpdateScheduleExercise()
            } catch {
                print("Error deleting ScheduleExercise")
            }
            
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

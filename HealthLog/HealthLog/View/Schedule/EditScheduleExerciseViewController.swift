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
    private var stepperValue = 0
    private var setValues: [(order: Int, weight: String, reps: String)] = []
    
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
    }
    
    private func updateSets() {
        // save inputs to setValues
        saveInputs()
        
        // trim setValues if stepperValue is less than setValues count
        print("setValues: \(setValues)")
        if setValues.count > stepperValue {
            setValues = Array(setValues.prefix(stepperValue))
        }
        print("setValues2: \(setValues)")
        
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
        print("\(setValues)")
        print("\(scheduleExercise)")
        
        var scheduleExerciseSets = List<ScheduleExerciseSet>()
        for i in 0..<setValues.count {
            let set = ScheduleExerciseSet(
                order: setValues[i].order,
                weight: Int(setValues[i].weight) ?? 0,
                reps: Int(setValues[i].reps) ?? 0,
                isCompleted: false
            )
            scheduleExerciseSets.append(set)
        }
        print("\(scheduleExerciseSets)")
        do {
            try realm.write {
                scheduleExercise.sets.removeAll()
                scheduleExercise.sets.append(objectsIn: scheduleExerciseSets)
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
}

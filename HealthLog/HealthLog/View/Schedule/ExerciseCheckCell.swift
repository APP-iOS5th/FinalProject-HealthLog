//
//  ExerciseTableViewCell.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import RealmSwift

protocol ExerciseCheckCellDelegate: AnyObject {
    func didTapEditExercise(_ exercise: ScheduleExercise)
    func didToggleExerciseCompletion(_ exercise: ScheduleExercise)
}

class ExerciseCheckCell: UITableViewCell {
    //    let realm = try! Realm()
    let realm = RealmManager.shared.realm
    
    static let identifier = "ExerciseCheckCell"
    
    weak var delegate: ExerciseCheckCellDelegate?
    private var currentExercise: ScheduleExercise?
    
    lazy var exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.font(.pretendardBold, ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var exerciseEditContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var exerciseEditButton: UIButton = {
        let button = UIButton(type: .system)
        
        var configuration = UIButton.Configuration.filled()
        configuration.title = "수정"
        configuration.baseBackgroundColor = .colorAccent
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    lazy var exerciseCompletedSwitch: UISwitch = {
        let checkbox = UISwitch()
        checkbox.onTintColor = .colorAccent
        checkbox.addTarget(self, action: #selector(didToggleCheckboxExercise(_:)), for: .valueChanged)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var setsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .colorPrimary
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(exerciseEditContainer)
        contentView.addSubview(separatorLine)
        contentView.addSubview(setsContainer)
        
        NSLayoutConstraint.activate([
            exerciseNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            exerciseEditContainer.topAnchor.constraint(equalTo: exerciseNameLabel.bottomAnchor, constant: 13),
            exerciseEditContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseEditContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            separatorLine.topAnchor.constraint(equalTo: exerciseEditContainer.bottomAnchor, constant: 13),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            separatorLine.heightAnchor.constraint(equalToConstant: 2),
            
            setsContainer.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 10),
            setsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            setsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with scheduleExercise: ScheduleExercise) {
        currentExercise = scheduleExercise
        exerciseNameLabel.text = scheduleExercise.exercise?.name
        createExerciseEditView(scheduleExercise)
        setsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for set in scheduleExercise.sets {
            let setView = createSetView(set: set)
            setsContainer.addArrangedSubview(setView)
        }
    }
    
    private func createExerciseEditView(_ scheduleExercise: ScheduleExercise) {
        exerciseEditButton.addTarget(self, action: #selector(editExercise), for: .touchUpInside)
        exerciseCompletedSwitch.isOn = scheduleExercise.isCompleted
        [exerciseEditButton, exerciseCompletedSwitch].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        let stackView = UIStackView(arrangedSubviews: [
            exerciseEditButton, exerciseCompletedSwitch
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        exerciseEditContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: exerciseEditContainer.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: exerciseEditContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: exerciseEditContainer.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: exerciseEditContainer.bottomAnchor),
            
            exerciseEditButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            exerciseCompletedSwitch.widthAnchor.constraint(greaterThanOrEqualToConstant: 51),
        ])
    }
    
    private func createSetView(set: ScheduleExerciseSet) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let setNumber = UILabel()
        setNumber.text = "\(set.order) 세트"
        setNumber.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setNumber.textColor = .white
        
        let weightLabel = UILabel()
        weightLabel.text = "\(set.weight) kg"
        weightLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        weightLabel.textColor = .white
        
        let repsLabel = UILabel()
        repsLabel.text = "\(set.reps) 회"
        repsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        repsLabel.textColor = .white
        
        let checkbox = UISwitch()
        checkbox.isOn = set.isCompleted
        checkbox.onTintColor = .colorAccent
        checkbox.tag = set.order
        checkbox.addTarget(self, action: #selector(didToggleCheckboxSet(_:)), for: .valueChanged)
        
        [setNumber, weightLabel, repsLabel, checkbox].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
        let stackView = UIStackView(arrangedSubviews: [
            setNumber, weightLabel, repsLabel, checkbox
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
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
    
    @objc private func didToggleCheckboxSet(_ sender: UISwitch) {
        // save it to the database
        guard let exercise = currentExercise else { return }
        
        let setOrder = sender.tag
        if let setIndex = exercise.sets.firstIndex(where: { $0.order == setOrder }) {
            do {
                if let scheduleExercise = realm.object(ofType: ScheduleExercise.self, forPrimaryKey: exercise.id) {
                    // update scheduleExerciseSet
                    try realm.write {
                        scheduleExercise.sets[setIndex].isCompleted = sender.isOn
                    }
                    
                    // update ScheduleExercise
                    let allSetsCompleted = scheduleExercise.sets.allSatisfy { $0.isCompleted }
                    exerciseCompletedSwitch.isOn = allSetsCompleted
                    try realm.write {
                        scheduleExercise.isCompleted = allSetsCompleted
                    }
                    
                    // update calendar and bodyparts image
                    // notice scheduleExercise changed
                    delegate?.didToggleExerciseCompletion(scheduleExercise)
                }
            } catch {
                print("Error update ScheduleExerciseSet")
            }
        }
    }
    
    @objc private func didToggleCheckboxExercise(_ sender: UISwitch) {
        // save it to the database
        guard let exercise = currentExercise else { return }
        
        do {
            if let scheduleExercise = realm.object(ofType: ScheduleExercise.self, forPrimaryKey: exercise.id) {
                // update scheduleExercise and the sets
                try realm.write {
                    scheduleExercise.isCompleted = sender.isOn
                    scheduleExercise.sets.forEach { $0.isCompleted = sender.isOn }
                }
                
                // update calendar and bodyparts image
                // notice scheduleExercise changed
                delegate?.didToggleExerciseCompletion(scheduleExercise)
            }
        } catch {
            print("Error update ScheduleExercise")
        }
    }
    
    @objc private func editExercise() {
        guard let exercise = currentExercise else { return }
        delegate?.didTapEditExercise(exercise)
    }
}

extension ExerciseCheckCell {
    func addSeparator() {
        let separator = UIView()
        separator.backgroundColor = .colorSecondary
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2),
        ])
    }
}

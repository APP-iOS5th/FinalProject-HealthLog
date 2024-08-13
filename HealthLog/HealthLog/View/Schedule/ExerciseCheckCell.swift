//
//  ExerciseTableViewCell.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class ExerciseCheckCell: UITableViewCell {
    static let identifier = "ExerciseCheckCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 13
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "ColorSecondary")
        contentView.addSubview(nameLabel)
        contentView.addSubview(setsContainer)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setsContainer.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 13),
            setsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with scheduleExercise: ScheduleExercise) {
        print("here")
        nameLabel.text = scheduleExercise.exercise?.name
        setsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
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
        let checkbox = UISwitch()
        checkbox.isOn = set.isCompleted
        checkbox.onTintColor = .white
        checkbox.addTarget(ExerciseCheckCell.self, action: #selector(didToggleCheckbox(_:)), for: .valueChanged)
        
        view.addSubview(setNumber)
        view.addSubview(weightLabel)
        view.addSubview(repsLabel)
        view.addSubview(checkbox)
        
        setNumber.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 30),
            
            setNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setNumber.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            weightLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            repsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 200),
            repsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            checkbox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkbox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }
    
    @objc private func didToggleCheckbox(_ sender: UISwitch) {
//        print("checkbox")
    }
}

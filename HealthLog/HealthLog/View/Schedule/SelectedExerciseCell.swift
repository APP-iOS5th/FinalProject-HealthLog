//
//  SelectedExerciseCell.swift
//  HealthLog
//
//  Created by seokyung on 8/13/24.
//

import UIKit

class SelectedExerciseCell: UITableViewCell {
    
    var exerciseTitleLabel: UILabel!
    var customStepper: TempViewController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        exerciseTitleLabel = UILabel()
        exerciseTitleLabel.font = UIFont(name: "Pretendard-Semibold", size: 16)
        exerciseTitleLabel.textColor = .white
        exerciseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exerciseTitleLabel)
        

        customStepper = TempViewController()
        guard let stepperView = customStepper.view else { return }
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepperView)
        
        NSLayoutConstraint.activate([
            exerciseTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            exerciseTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            exerciseTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stepperView.topAnchor.constraint(equalTo: exerciseTitleLabel.bottomAnchor),
            stepperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stepperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with exerciseName: String) {
        exerciseTitleLabel.text = exerciseName
    }
}

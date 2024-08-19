//
//  SelectedExerciseCell.swift
//  HealthLog
//
//  Created by seokyung on 8/13/24.
//

import UIKit

class SelectedExerciseCell: UITableViewCell {
    
    var exerciseTitleLabel = UILabel()
    var customStepper = TempViewController()
    var deleteButton = UIButton(type: .system)
    
    var deleteButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        exerciseTitleLabel.font = UIFont(name: "Pretendard-Semibold", size: 16)
        exerciseTitleLabel.textColor = .white
        exerciseTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exerciseTitleLabel)
        
        guard let stepperView = customStepper.view else { return }
        stepperView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stepperView)
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.tintColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            exerciseTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            exerciseTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            exerciseTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            
            stepperView.topAnchor.constraint(equalTo: exerciseTitleLabel.bottomAnchor),
            stepperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stepperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: exerciseTitleLabel.topAnchor, constant: 2),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deleteButton.widthAnchor.constraint(equalToConstant: 14),
            deleteButton.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
    
    @objc func deleteTapped() {
        deleteButtonTapped?()
    }

    func configure(with exerciseName: String) {
        exerciseTitleLabel.text = exerciseName
    }
}

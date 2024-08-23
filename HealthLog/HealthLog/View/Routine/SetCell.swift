//
//  RoutineExerciseStepperCollectionViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/22/24.
//

import UIKit

class SetCell: UICollectionViewCell {
    static let identifier = "SetCell"
    
    let setNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "무게"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let repsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "횟수"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(setNumberLabel)
        contentView.addSubview(weightTextField)
        contentView.addSubview(repsTextField)
        
        NSLayoutConstraint.activate([
            setNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            setNumberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weightTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: setNumberLabel.trailingAnchor, constant: 16),
            
            repsTextField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repsTextField.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 16),
            repsTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  RoutineExerciseStepperCollectionViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/22/24.
//

import UIKit

class SetCell: UICollectionViewCell {
    static let identifier = "SetCell"
    
    private lazy var setNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "무게"
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        
        textField.borderStyle = .none
        textField.backgroundColor = .color2F2F2F
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private lazy var weightTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kg"
        label.font =  UIFont.font(.pretendardMedium, ofSize: 14)
        return label
    }()
    
    private lazy var weightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weightTextField,weightTextLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    
    
    private lazy var repsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "횟수"
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.backgroundColor = .color2F2F2F

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
 
    
    private lazy var repsTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회"
        label.font =  UIFont.font(.pretendardMedium, ofSize: 14)
        return label
    }()
    private lazy var repsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repsTextField,repsTextLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [setNumberLabel, weightStackView, repsStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.containerStackView)
        NSLayoutConstraint.activate([
           
            self.containerStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.containerStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.weightTextField.widthAnchor.constraint(equalToConstant: 58),
            self.weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            self.repsTextField.widthAnchor.constraint(equalToConstant: 58),
            self.repsTextField.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with setNumber: Int ) {
        setNumberLabel.text = "\(setNumber) 세트"
        
    }
}

//
//  SetCountHeaderView.swift
//  HealthLog
//
//  Created by 어재선 on 8/23/24.
//

import UIKit

class SetCountHeaderView: UICollectionReusableView {
    static let identifier = "SetCountHeaderView"
    
    var setCountDidChange: ((Int) -> Void)?
    var setDelete: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 이름"
        label.font =  UIFont.font(.pretendardRegular, ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var xButton: UIButton = {
        let buttonAction = UIAction { _ in
            print("x 클릭")
            self.setDelete?()
           
        }
        
        let button = UIButton(primaryAction: buttonAction)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var setNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = .white
        label.font =  UIFont.font(.pretendardRegular, ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.layer.cornerRadius = 8
        stepper.backgroundColor = .colorAccent
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private lazy var titleNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "세트 수"
        label.textColor = .white
        label.font =  UIFont.font(.pretendardRegular, ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var setStepperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleNumberLabel, setNumberLabel, stepper])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.backgroundColor = .colorSecondary
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(xButton)
        self.addSubview(setStepperStackView)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 13),
            
            
            self.xButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            self.xButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
            self.xButton.widthAnchor.constraint(equalToConstant: 14),
            self.xButton.heightAnchor.constraint(equalToConstant: 14),
            
            self.setStepperStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            self.setStepperStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            self.setStepperStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
        ])
    }
    
    func configure(with exercise: RoutineExercise ) {
        titleLabel.text = exercise.exercise?.name
        stepper.value = Double(exercise.sets.count)
        setNumberLabel.text = "\(exercise.sets.count)"
        
    }
    
    @objc func stepperValueChanged(sender: UIStepper) {
        let value = Int(sender.value)
        setCountDidChange?(value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

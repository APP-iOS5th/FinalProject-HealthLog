//
//  SetCountHeaderView.swift
//  HealthLog
//
//  Created by 어재선 on 8/23/24.
//

import UIKit

class SetCountHeaderView: UICollectionReusableView {
    static let identifier = "SetCountHeaderView"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 이름"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var xButton: UIButton = {
        let buttonAction = UIAction { _ in
            print("x 클릭")
           
        }
        
        let button = UIButton(primaryAction: buttonAction)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "세트 수"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        self.addSubview(stepper)
        self.addSubview(titleLabel)
        self.addSubview(xButton)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.xButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.xButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            
            
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.label.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            
            
            self.stepper.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.stepper.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

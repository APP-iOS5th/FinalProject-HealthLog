//
//  SetCountHeaderView.swift
//  HealthLog
//
//  Created by 어재선 on 8/23/24.
//

import UIKit

class SetCountHeaderView: UICollectionReusableView {
    static let identifier = "SetCountHeaderView"
        
        let stepper: UIStepper = {
            let stepper = UIStepper()
            stepper.translatesAutoresizingMaskIntoConstraints = false
            return stepper
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.text = "세트 수"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
            addSubview(stepper)
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                stepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                stepper.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

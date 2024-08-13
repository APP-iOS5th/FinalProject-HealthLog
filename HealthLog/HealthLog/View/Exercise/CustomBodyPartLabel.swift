//
//  CustomBodyPartLabel.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import UIKit

class CustomBodyPartLabel: UILabel {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .colorPrimary
        textColor = .white
        font = UIFont.systemFont(ofSize: 14)
        textAlignment = .center
        layer.cornerRadius = 11
        layer.masksToBounds = true
    }
}

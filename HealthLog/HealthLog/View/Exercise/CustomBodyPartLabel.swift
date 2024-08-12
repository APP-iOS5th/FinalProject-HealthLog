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
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .center
        self.backgroundColor = .gray
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

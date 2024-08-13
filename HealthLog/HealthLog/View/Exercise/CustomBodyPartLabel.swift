//
//  CustomBodyPartLabel.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
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
        font = UIFont(name: "Pretendard-Medium", size: 12)
        textAlignment = .center
        layer.cornerRadius = 11
        layer.masksToBounds = true
    }
}

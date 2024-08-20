//
//  CustomBodyPartButton.swift
//  HealthLog
//
//  Created by user on 8/20/24.
//

import UIKit

class CustomBodyPartButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .colorPrimary
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .large
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration = buttonConfig
        titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
}

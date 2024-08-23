//
//  CustomBodyPartLabel.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import UIKit

class CustomBodyPartLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += (padding.top + padding.bottom)
        contentSize.width += (padding.left + padding.right)
        
        return contentSize
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .colorPrimary
        textColor = .white
        font = UIFont(name: "Pretendard-Medium", size: 12)
        textAlignment = .center
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
}

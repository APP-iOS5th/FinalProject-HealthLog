//
//  DividerFooterView.swift
//  HealthLog
//
//  Created by 어재선 on 8/25/24.
//

import UIKit

class DividerFooterView: UICollectionReusableView {
    static let identifier = "DividerFooterView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let divider = UIView()
        divider.backgroundColor = .colorSecondary
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

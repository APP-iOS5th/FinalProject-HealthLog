//
//  CollectionViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 9/2/24.
//

import UIKit

class DeleteButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "DeleteButtonCollectionViewCell"
    
    private lazy var deleteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "삭제"
        configuration.baseForegroundColor = .red
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 11, leading: 0, bottom: 11, trailing: 0)
        configuration.attributedTitle?.font = UIFont.font(.pretendardBold, ofSize: 14)
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .color2F2F2F
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.deleteButton)
        
        NSLayoutConstraint.activate([
            self.deleteButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.deleteButton.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            self.deleteButton.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            self.deleteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        
        ])
    }
    
    @objc func buttonTapped() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

//
//  TableHeaderView.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/6/24.
//

import UIKit

class TableHeaderView: UIView {

    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16)
        let symbolName = "list.bullet.clipboard.fill"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        imageView.image = symbol
        imageView.tintColor = .colorAccent
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .black)
        let symbolName = "list.bullet.clipboard"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        imageView.image = symbol
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "부위별 운동 내역"
        label.font = UIFont.font(.pretendardBold, ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        backgroundColor = .clear
        
        addSubview(titleBackgroundImage)
        addSubview(titleImage)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleBackgroundImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleBackgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            
            titleImage.centerYAnchor.constraint(equalTo: titleBackgroundImage.centerYAnchor),
            titleImage.centerXAnchor.constraint(equalTo: titleBackgroundImage.centerXAnchor),
            
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 13)
        ])
        
        
    }

}



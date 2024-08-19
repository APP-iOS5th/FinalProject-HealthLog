//
//  SectionTitleTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class SectionTitleTableViewCell: UITableViewCell {

    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16)
        let symbolName = "trophy.fill"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        imageView.image = symbol
        imageView.tintColor = .colorAccent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .black)
        let symbolName = "trophy"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        imageView.image = symbol
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가장 많이 한 운동"
        label.font = UIFont.font(.pretendardBold, ofSize: 16)
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleBackgroundImage)
        contentView.addSubview(titleImage)
        contentView.addSubview(titleLabel)
        
        
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleBackgroundImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleBackgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            
            titleImage.centerYAnchor.constraint(equalTo: titleBackgroundImage.centerYAnchor),
            titleImage.centerXAnchor.constraint(equalTo: titleBackgroundImage.centerXAnchor),
            
            
            titleLabel.centerYAnchor.constraint(equalTo: titleImage.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: 31)
        ])
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

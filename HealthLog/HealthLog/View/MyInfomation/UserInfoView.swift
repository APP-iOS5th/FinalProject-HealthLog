//
//  UserInfoView.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/10/24.
//

import UIKit

class UserInfoView: UIView {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.pretendardBold, ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.pretendardRegular, ofSize: 13)
        label.textColor = .colorBBBDBD
        label.text = "총 3일 운동 완료"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = .clear
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(completionLabel)
        
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            
            completionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            completionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            completionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(image: UIImage?, name: String, days: Int) {
        profileImageView.image = image
        nameLabel.text = name
        completionLabel.text = "총 \(days)일 운동 하였습니다."
    }
}

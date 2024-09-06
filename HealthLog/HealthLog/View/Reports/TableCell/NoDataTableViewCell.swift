//
//  NoDataTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/27/24.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

    static let identifier = "NoDataTableViewCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 기록이 없습니다."
        label.textColor = .color969696
        label.font = UIFont.font(.pretendardExtraBold, ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout() {
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48)
        ])
        
        
    }
}

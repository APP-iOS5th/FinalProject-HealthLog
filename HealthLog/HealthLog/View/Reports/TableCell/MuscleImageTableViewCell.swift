//
//  MuscleImageTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/19/24.
//

import UIKit

class MuscleImageTableViewCell: UITableViewCell {
    
    private let muscleImageView = MuscleImageView()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(muscleImageView)
        
        muscleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            muscleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            muscleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            muscleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            muscleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 13),
            
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: [ReportBodyPartData]) {
        muscleImageView.configureMuscleCell(data: data)
    }
}

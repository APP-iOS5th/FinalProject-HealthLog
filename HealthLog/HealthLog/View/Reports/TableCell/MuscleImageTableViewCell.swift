//
//  MuscleImageTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/19/24.
//

import UIKit

class MuscleImageTableViewCell: UITableViewCell {
    
    private let muscleImageView = MuscleImageView()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "한달 간 운동 기록"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color2F2F2F
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(divider)
        contentView.addSubview(muscleImageView)
        
        muscleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 8),
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            divider.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 8),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            muscleImageView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8),
            muscleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            muscleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(data: [ReportBodyPartData]) {
        muscleImageView.configureMuscleCell(data: data)
    }
}

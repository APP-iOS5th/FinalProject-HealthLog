//
//  MostPerformedTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class MostPerformedTableViewCell: UITableViewCell {
    
    private let exerciseIndexLabel: UILabel = {
        let label = UILabel()
        label.text = "1."
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    
    
    private let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "데드리프트"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let setsLabel: UILabel = {
        let label = UILabel()
        label.text = "30세트"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "7일"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(exerciseIndexLabel)
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(setsLabel)
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            
            exerciseIndexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            exerciseIndexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            exerciseIndexLabel.trailingAnchor.constraint(equalTo: exerciseNameLabel.leadingAnchor, constant: -13),
            exerciseIndexLabel.widthAnchor.constraint(equalToConstant: 30),
            
            exerciseNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: exerciseIndexLabel.trailingAnchor, constant: 13),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: setsLabel.leadingAnchor, constant: -13),
            
            setsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            setsLabel.trailingAnchor.constraint(equalTo: dayLabel.leadingAnchor, constant: -18),
            
            
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            dayLabel.widthAnchor.constraint(equalToConstant: 35)
            
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(data: ExerciseSets, index: Int) {
        exerciseIndexLabel.text = "\(index)등"
        exerciseNameLabel.text = data.name
        setsLabel.text = "\(data.setsCount)세트"
        dayLabel.text = "\(data.daysCount)일"
        
    }

}



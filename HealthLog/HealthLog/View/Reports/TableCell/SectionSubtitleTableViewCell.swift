//
//  SectionSubtitleTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/10/24.
//

import UIKit

// MARK: 각 Section 별 1번째 Row에 들어갈 cell 모음

// MARK: - 부위별 운동
class TotalNumberSectionSubtitleTableViewCell: UITableViewCell {
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.text = "#"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "운동이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 세트 수 레이블
    private lazy var setsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "세트 수"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 레이블 추가
        contentView.addSubview(indexLabel)
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(setsCountLabel)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            // indexLabel constraints
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 30),
            
            // exerciseNameLabel constraints
            exerciseNameLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 13),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            exerciseNameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            // setsCountLabel constraints
            setsCountLabel.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            setsCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 가장 많이 한 운동
class MostPerformedSectionSubtitleTableViewCell: UITableViewCell {
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.text = "#"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "운동이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 세트 수 레이블
    private lazy var setsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "세트 수"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daysCountLabel: UILabel = {
        let label = UILabel()
        label.text = "일 수"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 레이블 추가
        contentView.addSubview(indexLabel)
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(setsCountLabel)
        contentView.addSubview(daysCountLabel)
        
        exerciseNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            // indexLabel constraints
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 30),
            
            // exerciseNameLabel constraints
            exerciseNameLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 13),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            exerciseNameLabel.widthAnchor.constraint(equalToConstant: 120),
            
            // setsCountLabel constraints
            setsCountLabel.trailingAnchor.constraint(equalTo: daysCountLabel.leadingAnchor, constant: -18),
            setsCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daysCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daysCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            daysCountLabel.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 무게 변화가 가장 큰 운동
class MostChangedSectionSubtitleTableViewCell: UITableViewCell {
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.text = "#"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "운동이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 세트 수 레이블
    private lazy var minWeight: UILabel = {
        let label = UILabel()
        label.text = "최소 무게"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var maxWeight: UILabel = {
        let label = UILabel()
        label.text = "최대 무게"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 레이블 추가
        contentView.addSubview(indexLabel)
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(minWeight)
        contentView.addSubview(maxWeight)
        
        exerciseNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            // indexLabel constraints
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 30),
            
            // exerciseNameLabel constraints
            exerciseNameLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 13),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            exerciseNameLabel.widthAnchor.constraint(equalToConstant: 120),
            
            // setsCountLabel constraints
            minWeight.trailingAnchor.constraint(equalTo: maxWeight.leadingAnchor, constant: -28),
            minWeight.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            minWeight.widthAnchor.constraint(equalToConstant: 55),
            
            maxWeight.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            maxWeight.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            maxWeight.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

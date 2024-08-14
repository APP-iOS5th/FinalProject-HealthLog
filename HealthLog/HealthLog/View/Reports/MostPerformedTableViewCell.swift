//
//  MostPerformedTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class MostPerformedTableViewCell: UITableViewCell {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.spacing = 13
//        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let exerciseInfoView1 = PerformedExerciseInfoView()
        let exerciseInfoView2 = PerformedExerciseInfoView()
        
        stackView.addArrangedSubview(exerciseInfoView1)
        stackView.addArrangedSubview(exerciseInfoView2)
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 13),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

class PerformedExerciseInfoView: UIView {
    
    private let exerciseIndexLabel: UILabel = {
        let label = UILabel()
        label.text = "1."
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private let exerciseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "데드리프트"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsLabel: UILabel = {
        let label = UILabel()
        label.text = "30세트"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "7일"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(exerciseIndexLabel)
        addSubview(exerciseNameLabel)
        addSubview(setsLabel)
        addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            
            exerciseIndexLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            exerciseIndexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            exerciseNameLabel.leadingAnchor.constraint(equalTo: exerciseIndexLabel.trailingAnchor, constant: 20),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            setsLabel.leadingAnchor.constraint(equalTo: exerciseNameLabel.trailingAnchor, constant: 20),
            setsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
}

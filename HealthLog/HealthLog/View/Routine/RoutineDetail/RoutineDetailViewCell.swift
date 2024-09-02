//
//  RoutineDetailTableViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/28/24.
//

import UIKit

class RoutineDetailViewCell: UITableViewCell {

    static let cellId = "RoutineDetailTableViewCell"
    
    private lazy var setLabel: UILabel = {
        let label = UILabel()
        label.text = "0 세트"
        label.font = UIFont.font(.pretendardRegular, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var weightTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kg"
        label.textAlignment = .right
        label.textColor = .white
        label.font =  UIFont.font(.pretendardRegular, ofSize: 14)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    
    private lazy var repsTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회"
        label.textColor = .white
        label.textAlignment = .right
        label.font =  UIFont.font(.pretendardRegular, ofSize: 14)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        let stackView = UIStackView(arrangedSubviews: [setLabel,weightTextLabel,repsTextLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        self.contentView.addSubview(stackView)
        
        let padding:CGFloat = 43
        
        NSLayoutConstraint.activate([
            
            
            stackView.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            self.weightTextLabel.trailingAnchor.constraint(equalTo: stackView.centerXAnchor, constant: 17),
            self.repsTextLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
    }
    
    func configure(with routineExerciseSet: RoutineExerciseSet) {
        setLabel.text = "\(routineExerciseSet.order) 세트"
        weightTextLabel.text = "\(routineExerciseSet.weight) kg"
        repsTextLabel.text = "\(routineExerciseSet.reps) 회"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


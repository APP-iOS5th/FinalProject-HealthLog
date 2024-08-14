//
//  RoutineExerciseListTableViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/14/24.
//

import UIKit

class RoutineExerciseListTableViewCell: UITableViewCell {
    
    static let cellId = "RoutineExerciseListTableViewCell"
    
    // 운동이름
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 버튼
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let plusImage = UIImage(systemName: "plus.square.fill")?.withTintColor(.colorAccent, renderingMode: .alwaysOriginal).withConfiguration(config)
        button.setImage(plusImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24))
    }

    
    func setupUI() {
        self.backgroundColor = .colorPrimary
        self.contentView.backgroundColor = .colorSecondary
        self.contentView.layer.cornerRadius = 12
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(plusButton)
    
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            self.titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 22),
            
            self.plusButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.plusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -22),
           
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with exercise: Exercise) {
        titleLabel.text = exercise.name
    }
    
}

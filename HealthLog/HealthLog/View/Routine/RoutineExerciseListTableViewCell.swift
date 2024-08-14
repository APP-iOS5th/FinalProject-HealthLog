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
    // 최근 무게
    private lazy var recentWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 무게"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    // 최대 무게
    private lazy var maxWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "최대 무게"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    // 운동 부위 스크롤뷰
    private lazy var bodypartScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        
       return scrollView
        
    }()
    
    // 운동 부위 스텍뷰
    private lazy var bodypartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
        
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
        self.contentView.addSubview(recentWeightLabel)
        self.contentView.addSubview(maxWeightLabel)
        self.contentView.addSubview(bodypartScrollView)
        self.bodypartScrollView.addSubview(bodypartStackView)
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            self.titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 22),
            
            self.plusButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.plusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -22),
           
            self.recentWeightLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.recentWeightLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.maxWeightLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.maxWeightLabel.leadingAnchor.constraint(equalTo: self.recentWeightLabel.trailingAnchor,constant: 10),
            
            self.bodypartScrollView.topAnchor.constraint(equalTo: self.recentWeightLabel.bottomAnchor,constant: 4),
            self.bodypartScrollView.leadingAnchor.constraint(equalTo: self.recentWeightLabel.leadingAnchor),
            self.bodypartScrollView.trailingAnchor.constraint(equalTo: self.plusButton.leadingAnchor),
            self.bodypartScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 12),
            
            self.bodypartStackView.topAnchor.constraint(equalTo: self.bodypartScrollView.topAnchor),
            self.bodypartStackView.leadingAnchor.constraint(equalTo: self.bodypartScrollView.leadingAnchor),
            self.bodypartStackView.trailingAnchor.constraint(equalTo: self.bodypartScrollView.trailingAnchor),
            self.bodypartStackView.bottomAnchor.constraint(equalTo: self.bodypartScrollView.bottomAnchor),
            
            
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with exercise: Exercise) {
        titleLabel.text = exercise.name
        recentWeightLabel.text = "최근 무게: \(exercise.recentWeight)kg"
        maxWeightLabel.text = "최대 무게: \(exercise.maxWeight)kg"
        
        bodypartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for part in exercise.bodyParts {
            let label = CustomBodyPartLabel()
            label.text = part.rawValue
            bodypartStackView.addArrangedSubview(label)
        }
        
    }
    
}

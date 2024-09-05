//
//  MostPerformedTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class MostPerformedTableViewCell: UITableViewCell {

    private lazy var mostPerformStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // test sample
//    let testView1 = PerformedExerciseInfoView()
//    let testView2 = PerformedExerciseInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        stackView.addArrangedSubview(testView1)
//        stackView.addArrangedSubview(testView2)
        
        
        self.contentView.addSubview(mostPerformStackView)
        
        NSLayoutConstraint.activate([
            mostPerformStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            mostPerformStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            mostPerformStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            mostPerformStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(with data: [ExerciseSets]) {
        
        mostPerformStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        
        
        for i in 0..<data.count {
            let infoView = PerformedExerciseInfoView()
            infoView.configure(index: i+1, name: data[i].name , sets: data[i].setsCount, days: data[i].daysCount)
            mostPerformStackView.addArrangedSubview(infoView)
        }
        
    }

}

class PerformedExerciseInfoView: UIView {
    
    
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
        label.textAlignment = .center
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
            exerciseIndexLabel.widthAnchor.constraint(equalToConstant: 30),
            
    
            exerciseNameLabel.leadingAnchor.constraint(equalTo: exerciseIndexLabel.trailingAnchor, constant: 8),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            exerciseNameLabel.widthAnchor.constraint(equalToConstant: 140),
            
            
            setsLabel.leadingAnchor.constraint(equalTo: exerciseNameLabel.trailingAnchor, constant: 8),
            setsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: setsLabel.trailingAnchor, constant: 8),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            exerciseIndexLabel.heightAnchor.constraint(equalToConstant: 20),
            exerciseNameLabel.heightAnchor.constraint(equalTo: exerciseIndexLabel.heightAnchor),
            setsLabel.heightAnchor.constraint(equalTo: exerciseIndexLabel.heightAnchor),
            dayLabel.heightAnchor.constraint(equalTo: exerciseIndexLabel.heightAnchor)
        ])
    }
    
    func configure(index: Int, name: String, sets: Int, days: Int) {
        
        exerciseIndexLabel.text = "\(index)."
        exerciseNameLabel.text = name
        setsLabel.text = "\(sets)세트"
        dayLabel.text = "\(days)일"
        
    }
    
}

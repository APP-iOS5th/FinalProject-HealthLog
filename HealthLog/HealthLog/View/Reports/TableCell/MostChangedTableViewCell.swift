//
//  MostChangedTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class MostChangedTableViewCell: UITableViewCell {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let testView1 = ExerciseRankingInfoView()
    let testView2 = ExerciseRankingInfoView()
    let testView3 = ExerciseRankingInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stackView.addArrangedSubview(testView1)
        stackView.addArrangedSubview(testView2)
        stackView.addArrangedSubview(testView3)
        
        
        self.contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


class ExerciseRankingInfoView: UIView {
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
    
    private let previousWeightlabel: UILabel = {
        let label = UILabel()
        label.text = "40KG"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heaviestWeightlabel: UILabel = {
        let label = UILabel()
        label.text = "70KG"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var rightArrow: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let symbolName = "arrow.forward"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        imageView.image = symbol
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var squareView: UIView = {
        let sqView = UIView()
        sqView.backgroundColor = UIColor.colorAccent
        sqView.layer.cornerRadius = 10
        sqView.translatesAutoresizingMaskIntoConstraints = false
        
        return sqView
        
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
        addSubview(previousWeightlabel)
        addSubview(rightArrow)
        addSubview(squareView)
        addSubview(heaviestWeightlabel)
        
        
        
        
        NSLayoutConstraint.activate([
            
            exerciseIndexLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            exerciseIndexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            exerciseNameLabel.leadingAnchor.constraint(equalTo: exerciseIndexLabel.trailingAnchor, constant: 8),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            previousWeightlabel.leadingAnchor.constraint(equalTo: exerciseNameLabel.trailingAnchor, constant: 8),
            previousWeightlabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightArrow.leadingAnchor.constraint(equalTo: previousWeightlabel.trailingAnchor, constant: 8),
            rightArrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            heaviestWeightlabel.leadingAnchor.constraint(equalTo: rightArrow.trailingAnchor, constant: 22),
            heaviestWeightlabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            squareView.centerYAnchor.constraint(equalTo: heaviestWeightlabel.centerYAnchor),
            squareView.centerXAnchor.constraint(equalTo: heaviestWeightlabel.centerXAnchor),
            
            squareView.heightAnchor.constraint(equalToConstant: 30),
            squareView.widthAnchor.constraint(equalToConstant: 50),
           
        ])
    }
    
}

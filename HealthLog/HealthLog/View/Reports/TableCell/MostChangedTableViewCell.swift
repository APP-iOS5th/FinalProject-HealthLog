//
//  MostChangedTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class MostChangedTableViewCell: UITableViewCell {

    private lazy var mostChangedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        stackView.alignment = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
//    let testView1 = ExerciseRankingInfoView()
//    let testView2 = ExerciseRankingInfoView()
//    let testView3 = ExerciseRankingInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        mostChangedStackView.addArrangedSubview(testView1)
//        mostChangedStackView.addArrangedSubview(testView2)
//        mostChangedStackView.addArrangedSubview(testView3)
        
        
        self.contentView.addSubview(mostChangedStackView)
        
        NSLayoutConstraint.activate([
            mostChangedStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            mostChangedStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            mostChangedStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            mostChangedStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with data: [ExerciseSets]) {
        
        mostChangedStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        
        for i in 0..<data.count {
            let infoView = ExerciseRankingInfoView()
            infoView.configure(index: i+1, name: data[i].name, preWeight: data[i].minWeight, heavyWeight: data[i].maxWeight)
            mostChangedStackView.addArrangedSubview(infoView)
            
        }
        
        
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
    
    func configure(index: Int, name: String, preWeight: Int, heavyWeight: Int) {
        
        exerciseIndexLabel.text = "\(index)."
        exerciseNameLabel.text = name
        previousWeightlabel.text = "\(preWeight)KG"
        heaviestWeightlabel.text = "\(heavyWeight)KG"
        
    }
    
}

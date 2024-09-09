//
//  MostChangedTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/14/24.
//

import UIKit

class MostChangedTableViewCell: UITableViewCell {

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
        label.textAlignment = .left
        return label
    }()
    
    private let previousWeightlabel: UILabel = {
        let label = UILabel()
        label.text = "40KG"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        

        contentView.addSubview(exerciseIndexLabel)
        contentView.addSubview(exerciseNameLabel)
        contentView.addSubview(squareView)
        contentView.addSubview(previousWeightlabel)
        contentView.addSubview(heaviestWeightlabel)
        contentView.addSubview(rightArrow)
        
        
        
        NSLayoutConstraint.activate([
            exerciseIndexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            exerciseIndexLabel.widthAnchor.constraint(equalToConstant: 30),
            exerciseIndexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            exerciseNameLabel.leadingAnchor.constraint(equalTo: exerciseIndexLabel.trailingAnchor, constant: 8),
            exerciseNameLabel.trailingAnchor.constraint(equalTo: previousWeightlabel.leadingAnchor, constant: -8),
            exerciseNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            previousWeightlabel.leadingAnchor.constraint(equalTo: exerciseNameLabel.trailingAnchor, constant: 8),
            previousWeightlabel.trailingAnchor.constraint(equalTo: rightArrow.leadingAnchor, constant: -8),
            previousWeightlabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightArrow.trailingAnchor.constraint(equalTo: squareView.leadingAnchor, constant:  -8),
            rightArrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightArrow.widthAnchor.constraint(equalToConstant: 20),
            
            
            heaviestWeightlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            heaviestWeightlabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            heaviestWeightlabel.widthAnchor.constraint(equalToConstant: 50),
            
            squareView.centerYAnchor.constraint(equalTo: heaviestWeightlabel.centerYAnchor),
            squareView.centerXAnchor.constraint(equalTo: heaviestWeightlabel.centerXAnchor),
            
            squareView.heightAnchor.constraint(equalToConstant: 30),
            squareView.widthAnchor.constraint(equalToConstant: 50),

        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with data: ExerciseSets, index: Int) {
        exerciseIndexLabel.text = "\(index)등"
        exerciseNameLabel.text = data.name
        previousWeightlabel.text = "\(data.minWeight)KG"
        heaviestWeightlabel.text = "\(data.maxWeight)KG"
        
    }
    

}



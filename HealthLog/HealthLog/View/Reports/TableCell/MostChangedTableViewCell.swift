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
        label.backgroundColor = .colorAccent
        
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
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
        return imageView
    }()
    
}

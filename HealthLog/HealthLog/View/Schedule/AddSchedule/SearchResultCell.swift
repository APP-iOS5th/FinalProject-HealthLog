//
//  SearchResultCell.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class SearchResultCell: UITableViewCell {
    var addButtonTapped: (() -> Void)?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.font(.pretendardBold, ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let recentWeightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxWeightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyPartsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let bodyPartsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        button.setImage(plusImage, for: .normal)
        button.backgroundColor = .colorAccent
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .colorSecondary
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(recentWeightLabel)
        contentView.addSubview(maxWeightLabel)
        contentView.addSubview(bodyPartsScrollView)
        bodyPartsScrollView.addSubview(bodyPartsStackView)
        contentView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            
            recentWeightLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            recentWeightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            maxWeightLabel.leadingAnchor.constraint(equalTo: recentWeightLabel.trailingAnchor, constant: 4),
            maxWeightLabel.topAnchor.constraint(equalTo: recentWeightLabel.topAnchor),
            
            bodyPartsScrollView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyPartsScrollView.topAnchor.constraint(equalTo: recentWeightLabel.bottomAnchor, constant: 6),
            bodyPartsScrollView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            bodyPartsScrollView.heightAnchor.constraint(equalToConstant: 33),
            
            bodyPartsStackView.leadingAnchor.constraint(equalTo: bodyPartsScrollView.leadingAnchor),
            bodyPartsStackView.topAnchor.constraint(equalTo: bodyPartsScrollView.topAnchor),
            bodyPartsStackView.trailingAnchor.constraint(equalTo: bodyPartsScrollView.trailingAnchor),
            bodyPartsStackView.bottomAnchor.constraint(equalTo: bodyPartsScrollView.bottomAnchor),
            
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0))
    }
    
    @objc func addTapped() {
        addButtonTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with exercise: Exercise) {
        titleLabel.text = exercise.name
        recentWeightLabel.text = "최근 무게: \(exercise.recentWeight)kg"
        maxWeightLabel.text = "최대 무게: \(exercise.maxWeight)kg"
        
        bodyPartsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        exercise.bodyParts.forEach { bodyPart in
            let label = UILabel()
            label.text = bodyPart.rawValue
            label.font = UIFont.font(.pretendardMedium, ofSize: 13)
            label.textColor = .white
            label.backgroundColor = .colorPrimary
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + 16).isActive = true
            label.heightAnchor.constraint(equalToConstant: 33).isActive = true
            
            bodyPartsStackView.addArrangedSubview(label)
        }
    }
}

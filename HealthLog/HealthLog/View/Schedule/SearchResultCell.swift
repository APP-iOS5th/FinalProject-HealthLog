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
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let plusImage = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(config)
        button.setImage(plusImage, for: .normal)
        button.backgroundColor = UIColor(named: "ColorAccent")
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
        contentView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            
            recentWeightLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            recentWeightLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            
            maxWeightLabel.leadingAnchor.constraint(equalTo: recentWeightLabel.trailingAnchor, constant: 4),
            maxWeightLabel.topAnchor.constraint(equalTo: recentWeightLabel.topAnchor),
            
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
    }
    
}

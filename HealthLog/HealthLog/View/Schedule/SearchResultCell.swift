//
//  SearchResultCell.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    var addButtonTapped: (() -> Void)?
    
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
        
        contentView.addSubview(addButton)
        contentView.backgroundColor = UIColor(named: "ColorSecondary")
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),
        ])
    }
    
    @objc func addTapped() {
        addButtonTapped?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

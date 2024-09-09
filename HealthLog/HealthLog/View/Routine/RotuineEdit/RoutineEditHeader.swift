//
//  RoutineEditHeader.swift
//  HealthLog
//
//  Created by 어재선 on 9/6/24.
//

import UIKit

class RoutineEditHeader: UITableViewHeaderFooterView {
    
    static let cellId = "RoutineEditHeader"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Section"
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 10)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .color2F2F2F
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            self.divider.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 3),
            self.divider.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.divider.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    
    func configure(with sectionTitle: String) {
        titleLabel.text = sectionTitle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

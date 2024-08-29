//
//  RoutineDetailHeaderFotterView.swift
//  HealthLog
//
//  Created by 어재선 on 8/28/24.
//

import UIKit

class RoutineDetailHeaderView: UITableViewHeaderFooterView {
    
    static let cellId = "RoutineDetailTableHeaderView"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 이름"
        label.font =  UIFont.font(.pretendardBold, ofSize: 16)
        label.textColor = .white
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
        self.backgroundColor = .clear
        let padding:CGFloat = 43
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            self.divider.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 3),
            self.divider.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.divider.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    
    func configure(with exerciseName: String) {
        titleLabel.text = exerciseName
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

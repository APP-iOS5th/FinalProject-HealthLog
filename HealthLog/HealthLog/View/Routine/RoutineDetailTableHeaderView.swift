//
//  RoutineDetailHeaderFotterView.swift
//  HealthLog
//
//  Created by 어재선 on 8/28/24.
//

import UIKit

class RoutineDetailTableHeaderView: UITableViewHeaderFooterView {
    
    static let cellId = "RoutineDetailTableHeaderView"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 이름"
        label.font =  UIFont.font(.pretendardMedium, ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
        ])
        
    }
    
    
    func configure(with exerciseName: String) {
        titleLabel.text = exerciseName
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

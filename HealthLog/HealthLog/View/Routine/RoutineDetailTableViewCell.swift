//
//  RoutineDetailTableViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/28/24.
//

import UIKit

class RoutineDetailTableViewCell: UITableViewCell {

    static let cellId = "RoutineDetailTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()


}

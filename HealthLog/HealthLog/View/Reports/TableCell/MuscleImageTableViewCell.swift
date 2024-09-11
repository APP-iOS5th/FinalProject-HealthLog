//
//  MuscleImageTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/19/24.
//

import UIKit

class MuscleImageTableViewCell: UITableViewCell {

    private let muscleImageView = MuscleImageView()

    // 원형과 단계를 위한 스택뷰
    private let levelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 단계 레이블
    private let levels = ["1단계", "2단계", "3단계", "4단계", "5단계"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(muscleImageView)
        contentView.addSubview(levelStackView)
        
        muscleImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            muscleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            muscleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            muscleImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            muscleImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        NSLayoutConstraint.activate([
            levelStackView.bottomAnchor.constraint(equalTo: muscleImageView.bottomAnchor, constant: 40),
            levelStackView.trailingAnchor.constraint(equalTo: muscleImageView.trailingAnchor, constant: 24)
        ])

        setupLevelCircles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLevelCircles() {
        for (index, level) in levels.enumerated() {
            let colorName = "ColorStep\(index + 1)"
            let circleView = createCircleView(colorName: colorName)
            let levelLabel = createLevelLabel(text: level)
            
            let levelStack = UIStackView(arrangedSubviews: [circleView, levelLabel])
            levelStack.axis = .horizontal
            levelStack.spacing = 8
            levelStack.alignment = .center
            
            levelStackView.addArrangedSubview(levelStack)
        }
    }

    private func createCircleView(colorName: String) -> UIView {
        let circleView = UIView()
        circleView.backgroundColor = UIColor(named: colorName)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.layer.cornerRadius = 6
        circleView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 12),
            circleView.heightAnchor.constraint(equalToConstant: 12)
        ])
        return circleView
    }

    private func createLevelLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.font(.pretendardLight, ofSize: 8)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func configureCell(data: [ReportBodyPartData]) {
        muscleImageView.configureMuscleCell(data: data)
    }
}

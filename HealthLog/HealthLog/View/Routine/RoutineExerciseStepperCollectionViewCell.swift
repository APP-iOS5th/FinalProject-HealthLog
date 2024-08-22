//
//  RoutineExerciseStepperCollectionViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/22/24.
//

import UIKit

class RoutineExerciseStepperCollectionViewCell: UICollectionViewCell {
    
      // 셀에 추가할 서브뷰 정의
      private let label: UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.textAlignment = .center
          return label
      }()
      
      // 셀 초기화
      override init(frame: CGRect) {
          super.init(frame: frame)
          self.contentView.backgroundColor = .colorPrimary
          contentView.addSubview(label)
          setupConstraints()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      // 셀의 레이아웃 설정
      private func setupConstraints() {
          NSLayoutConstraint.activate([
              label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
              label.topAnchor.constraint(equalTo: contentView.topAnchor),
              label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
          ])
      }
      
      // 셀의 데이터 설정
      func configure(with text: String) {
          label.text = text
      }
    
    
}

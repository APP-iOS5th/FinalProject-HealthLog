//
//  InfoBody.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/31/24.
//

import UIKit

// MARK: - InfoBox
class InfoBoxView: UIView {
    private let titleLabel: UILabel
    private let valueLabel: UILabel
    private let unitLabel: UILabel
    
    init(title: String, value: String, unit: String) {
        titleLabel = UILabel()
        valueLabel = UILabel()
        unitLabel = UILabel()
        
        super.init(frame: .zero)
        
        setupView(title: title, value: value, unit: unit)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    private func setupView(title: String, value: String, unit: String) {
        backgroundColor = .color2F2F2F
        layer.cornerRadius = 7
        
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
        titleLabel.textAlignment = .center
        
        let dividerView = UIView()
        dividerView.backgroundColor = .color3E3E3E
        
        valueLabel.text = value
        valueLabel.textColor = .white
        valueLabel.font = UIFont.font(.pretendardBold, ofSize: 25)
        valueLabel.textAlignment = .center
        
        unitLabel.text = unit
        unitLabel.textColor = .white
        unitLabel.font = UIFont.font(.pretendardRegular, ofSize: 12)
        unitLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(dividerView)
        addSubview(valueLabel)
        addSubview(unitLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            valueLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 2),
            unitLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -3),
        ])
    }
    
    func updateValue(_ newValue: String) {
        valueLabel.text = newValue
    }
}

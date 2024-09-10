//
//  InfoBody.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/31/24.
//

import UIKit

class InfoBoxView: UIView {
    private let weightBoxContentView = InbodyContentView()
    private let musclesBoxContentView = InbodyContentView()
    private let fatBoxContentView = InbodyContentView()
    
    func updateValues(weight: Double, muscleMass: Double, bodyFat: Double) {
        weightBoxContentView.reloadValueLabel(unit: "kg", value: String(format: "%.1f", weight))
        musclesBoxContentView.reloadValueLabel(unit: "kg", value: String(format: "%.1f", muscleMass))
        fatBoxContentView.reloadValueLabel(unit: "%", value: String(format: "%.1f", bodyFat))
    }
    
    init() {
        super.init(frame: .zero)
        setupInfoBoxGroup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInfoBoxGroup()
    }
    
    func setupInfoBoxGroup() {
        backgroundColor = .color2F2F2F
        layer.cornerRadius = 7
        
        let stackView = UIStackView(arrangedSubviews: [weightBoxContentView, musclesBoxContentView, fatBoxContentView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        
        weightBoxContentView.configure(symbolName: "square.stack.3d.up", title: "몸무게")
        musclesBoxContentView.configure(symbolName: "scalemass", title: "골격근량")
        fatBoxContentView.configure(symbolName: "flame", title: "체지방률")
    }
}

class InbodyContentView: UIView {
    private let symbolImageContentView = UIImageView()
    private let symbolImageBorderView = UIImageView()
    private let titleLabel = UILabel()
    private let dividerView = UIView()
    private let valueLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .color3E3E3E
        layer.cornerRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [symbolImageContentView, titleLabel, dividerView, valueLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 9
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        
        symbolImageContentView.contentMode = .scaleAspectFit
        symbolImageContentView.tintColor = .colorAccent
        
        symbolImageBorderView.contentMode = .scaleAspectFit
        symbolImageBorderView.tintColor = .white
        symbolImageContentView.addSubview(symbolImageBorderView)
        symbolImageBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            symbolImageBorderView.centerXAnchor.constraint(equalTo: symbolImageContentView.centerXAnchor),
            symbolImageBorderView.centerYAnchor.constraint(equalTo: symbolImageContentView.centerYAnchor),
        ])
        
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 15)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        
        dividerView.backgroundColor = .color525252
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
        ])
        
        valueLabel.textColor = .white
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.7
    }
    
    func configure(symbolName: String, title: String) {
        titleLabel.text = title
        imageConfigure(symbolName: symbolName)
    }
    
    func reloadValueLabel(unit: String, value: String) {
        valueLabel.attributedText = attributedString(value: value, unit: unit)
    }
    
    private func attributedString(value: String, unit: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.85
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 25) ?? UIFont.systemFont(ofSize: 25, weight: .bold),
            .paragraphStyle: paragraphStyle]
        let valueString = NSAttributedString(string: value, attributes: valueAttributes)
        
        let kgAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)]
        let kgString = NSAttributedString(string: unit, attributes: kgAttributes)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(valueString)
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(kgString)
        return attributedString
    }
    
    private func imageConfigure(symbolName: String) {
        symbolImageContentView.image = UIImage(systemName: symbolName + ".fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        symbolImageBorderView.image = UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        guard symbolName == "scalemass" else { return }
        let symbolImageContentKGLabel = UILabel()
        symbolImageContentKGLabel.text = "KG"
        symbolImageContentKGLabel.textColor = .white
        symbolImageContentKGLabel.font = UIFont(name: "Pretendard-Bold", size: 10)
        symbolImageBorderView.addSubview(symbolImageContentKGLabel)
        symbolImageContentKGLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            symbolImageContentKGLabel.centerXAnchor.constraint(equalTo: symbolImageBorderView.centerXAnchor),
            symbolImageContentKGLabel.centerYAnchor.constraint(equalTo: symbolImageBorderView.centerYAnchor, constant: 5),
        ])
    }
}

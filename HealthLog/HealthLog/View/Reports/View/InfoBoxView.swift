//
//  InfoBody.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/31/24.
//

import UIKit
import Combine

// MARK: - InfoBox
class InfoBoxView: UIView {
    private let stackView = UIStackView()
    private let inbodyLabel = UILabel()
    private let inbodyStackView = UIStackView()
    private let weightBoxContentStackView = InbodyContentStackView()
    private let musclesBoxContentStackView = InbodyContentStackView()
    private let fatBoxContentStackView = InbodyContentStackView()
    
    func updateValues(weight: Double, muscleMass: Double, bodyFat: Double) {
        weightBoxContentStackView.reloadValueLabel(unit: "kg", value: String(format: "%.1f", weight))
        musclesBoxContentStackView.reloadValueLabel(unit: "kg", value: String(format: "%.1f", muscleMass))
        fatBoxContentStackView.reloadValueLabel(unit: "%", value: String(format: "%.1f", bodyFat))
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
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 13, left: 30, bottom: 13, right: 30)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        inbodyLabel.text = "  최근 인바디 정보"
        inbodyLabel.textColor = .white
        inbodyLabel.font = UIFont(name: "Pretendard-Bold", size: 16)
        stackView.addArrangedSubview(inbodyLabel)
        
        inbodyStackView.axis = .horizontal
        inbodyStackView.alignment = .center
        inbodyStackView.distribution = .fillEqually
        inbodyStackView.spacing = 15
        inbodyStackView.layer.cornerRadius = 10
        inbodyStackView.clipsToBounds = true
        inbodyStackView.isLayoutMarginsRelativeArrangement = true
        inbodyStackView.layoutMargins = UIEdgeInsets(
            top: 15, left: 15, bottom: 15, right: 15)
        inbodyStackView.backgroundColor = .color3E3E3E
        stackView.addArrangedSubview(inbodyStackView)
        
        weightBoxContentStackView
            .configure(symbolName: "square.stack.3d.up", title: "몸무게")
        inbodyStackView.addArrangedSubview(weightBoxContentStackView)
        
        musclesBoxContentStackView
            .configure(symbolName: "scalemass", title: "골격근량")
        inbodyStackView.addArrangedSubview(musclesBoxContentStackView)
        
        fatBoxContentStackView
            .configure(symbolName: "flame", title: "체지방률")
        inbodyStackView.addArrangedSubview(fatBoxContentStackView)
    }
    
    
    // MARK: - InbodyContentStackView
    private class InbodyContentStackView: UIStackView {
        
        // MARK: Properties
        
        private let symbolImageContentView = UIImageView()
        private let symbolImageBorderView = UIImageView()
        private let titleLabel = UILabel()
        private let dividerView = UIView()
        private let valueLabel = UILabel()
        
        // MARK: Initializers
        
        init() {
            super.init(frame: .zero)
            setupUI()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: Setup
        
        private func setupUI() {
            axis = .vertical
            alignment = .center
            spacing = 9
            distribution = .equalSpacing
            layer.cornerRadius = 10
            clipsToBounds = true
            isLayoutMarginsRelativeArrangement = true
            layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            backgroundColor = .color2F2F2F
            
            // MARK: symbolImageView
            symbolImageContentView.contentMode = .scaleAspectFit
            symbolImageContentView.tintColor = .colorAccent
            addArrangedSubview(symbolImageContentView)
            
            symbolImageBorderView.contentMode = .scaleAspectFit
            symbolImageBorderView.tintColor = .white
            symbolImageContentView.addSubview(symbolImageBorderView)
            symbolImageBorderView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                symbolImageBorderView.centerXAnchor.constraint(
                    equalTo: symbolImageContentView.centerXAnchor),
                symbolImageBorderView.centerYAnchor.constraint(
                    equalTo: symbolImageContentView.centerYAnchor),
            ])
            
            
            // MARK: titleLabel
            titleLabel.font = UIFont(name: "Pretendard-Bold", size: 15)
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.5
            addArrangedSubview(titleLabel)
            
            // MARK: dividerView
            dividerView.backgroundColor = .color525252
            addArrangedSubview(dividerView)
            dividerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dividerView.heightAnchor.constraint(
                    equalToConstant: 1),
                dividerView.widthAnchor.constraint(
                    equalTo: widthAnchor, constant: -20),
            ])
            
            // MARK: valueLabel
            valueLabel.textColor = .white
            valueLabel.textAlignment = .center
            valueLabel.adjustsFontSizeToFitWidth = true
            valueLabel.minimumScaleFactor = 0.7
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(valueLabel)
        }
        
        func configure(symbolName: String, title: String) {
            titleLabel.text = title
            imageConfigure(symbolName: symbolName)
        }
        
        func reloadValueLabel(unit: String, value: String) {
            valueLabel.attributedText = attributedString(value: value, unit: unit)
        }
        
        // MARK: Sub Methods
        
        private func attributedString(value: String, unit: String) -> NSMutableAttributedString {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.85
            
            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Pretendard-Bold", size: 25) ??
                UIFont.systemFont(ofSize: 25, weight: .bold),
                .paragraphStyle: paragraphStyle]
            let valueString = NSAttributedString(
                string: value, attributes: valueAttributes)
            
            let kgAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Pretendard-Bold", size: 12) ??
                UIFont.systemFont(ofSize: 12, weight: .bold)]
            let kgString = NSAttributedString(
                string: unit, attributes: kgAttributes)
            
            let attributedString = NSMutableAttributedString()
            attributedString.append(valueString)
            attributedString.append(NSAttributedString(string: " "))
            attributedString.append(kgString)
            return attributedString
        }
        
        private func imageConfigure(symbolName: String) {
            symbolImageContentView.image = UIImage(
                systemName: symbolName + ".fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            
            symbolImageBorderView.image = UIImage(
                systemName: symbolName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            
            guard symbolName == "scalemass" else { return }
            let symbolImageContentKGLabel = UILabel()
            symbolImageContentKGLabel.text = "KG"
            symbolImageContentKGLabel.textColor = .white
            symbolImageContentKGLabel.font = UIFont(name: "Pretendard-Bold", size: 10)
            symbolImageBorderView.addSubview(symbolImageContentKGLabel)
            symbolImageContentKGLabel
                .translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                symbolImageContentKGLabel.centerXAnchor.constraint(
                    equalTo: symbolImageBorderView.centerXAnchor),
                symbolImageContentKGLabel.centerYAnchor.constraint(
                    equalTo: symbolImageBorderView.centerYAnchor,
                    constant: 5),
            ])
        }
    }
}

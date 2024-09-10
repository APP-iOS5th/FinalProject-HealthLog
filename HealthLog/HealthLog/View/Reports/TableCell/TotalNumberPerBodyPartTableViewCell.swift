//
//  TotalNumberPerBodyPartTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class TotalNumberPerBodyPartTableViewCell: UITableViewCell {
    
    // cell의 위치
    private var indexPath: IndexPath?
    
    private var isStackViewVisibility = false {
        didSet {
            if isStackViewVisibility {
                if exerciseStackView.superview == nil {
                    contentView.addSubview(exerciseStackView)
                    NSLayoutConstraint.activate([
                        exerciseStackView.topAnchor.constraint(equalTo: bodyPartLabel.bottomAnchor, constant: 13),
                        exerciseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
                        exerciseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 76),
                        exerciseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26)
                    ])
                }
            } else {
                exerciseStackView.removeFromSuperview()
            }
            
            updateFoldingImage()
            
            
            if let tableView = superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
        }
    }
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.text = "01"
        label.font = UIFont.font(.pretendardBold, ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bodyPartLabel: UILabel = {
        let label = UILabel()
        label.text = "삼두"
        label.font = UIFont.font(.pretendardBold, ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = UIColor(named: "Color5A5A5A")
        view.progressTintColor = UIColor(named: "ColorAccent")
        view.progress = 0.5
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        // 안쪽 게이지 둥글게
        view.layer.sublayers![1].cornerRadius = 5
        view.subviews[1].clipsToBounds = true
        
        return view
    }()
    
    private lazy var totalNumberPerBodyPartLabel: UILabel = {
        let label = UILabel()
        label.text = "27세트"
        label.font = UIFont.font(.pretendardBold, ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var foldingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var exerciseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
//        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(indexLabel)
        contentView.addSubview(bodyPartLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(totalNumberPerBodyPartLabel)
        contentView.addSubview(foldingImage)
        

        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        totalNumberPerBodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        foldingImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        exerciseStackView.axis = .vertical
        exerciseStackView.alignment = .leading
        exerciseStackView.distribution = .equalSpacing
        exerciseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            
            
            indexLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            indexLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            indexLabel.widthAnchor.constraint(equalToConstant: 30),
            
            bodyPartLabel.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 24),
            bodyPartLabel.centerYAnchor.constraint(equalTo: indexLabel.centerYAnchor),
            bodyPartLabel.widthAnchor.constraint(equalToConstant: 80),
            
            progressView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: indexLabel.centerYAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 60),
            progressView.heightAnchor.constraint(equalToConstant: 22),
            
            totalNumberPerBodyPartLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            totalNumberPerBodyPartLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 11),
            
            
            foldingImage.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            foldingImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            foldingImage.centerYAnchor.constraint(equalTo: indexLabel.centerYAnchor),
            foldingImage.widthAnchor.constraint(equalToConstant: 20)
            
        ])
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateFoldingImage() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let symbolName = isStackViewVisibility ? "chevron.up" : "chevron.down"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        foldingImage.image = symbol
    }
    
    
    func toggleStackViewVisibility() {
        isStackViewVisibility.toggle()
    }
    
    func configureCell(with data: ReportBodyPartData, at indexPath: IndexPath, maxTotalSets: Int, index: Int) {
        
        indexLabel.text = index < 10 ? "0\(index)" : "\(index)"
        bodyPartLabel.text = "\(data.bodyPart)"
        totalNumberPerBodyPartLabel.text = "\(data.totalSets)세트"
        // 추후 최대 값에 맞출 예정
        if maxTotalSets > 0 {
            progressView.progress = Float(data.totalSets) / Float(maxTotalSets)
        } else {
            progressView.progress = 0
        }
        
        exerciseStackView.arrangedSubviews.forEach {$0.removeFromSuperview() }
        
        var index = 1
        
        for exercise in data.exercises {
            let exerciseView = HorizontalDetailStackView()
            exerciseView.configure(name: exercise.name, setsCount: exercise.setsCount)
            exerciseStackView.addArrangedSubview(exerciseView)
            index += 1
        }
        
        self.indexPath = indexPath
        isStackViewVisibility = data.isStackViewVisible
        
    }
}

class HorizontalDetailStackView: UIView {
    
    private let nameLabel = UILabel()
    private let setsLabel = UILabel()
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func changeLabelFontAndColor() {
        
        nameLabel.font = UIFont.font(.pretendardRegular, ofSize: 14)
        nameLabel.textColor = .colorBBBDBD
        
        setsLabel.font = UIFont.font(.pretendardRegular, ofSize: 14)
        setsLabel.textColor = .colorBBBDBD
        setsLabel.textAlignment = .right
    }
    
    
    private func setupView() {
        
        changeLabelFontAndColor()
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        setsLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(setsLabel)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            setsLabel.widthAnchor.constraint(equalToConstant: 60),
            setsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
        
    }
    
    func configure(name: String, setsCount: Int) {
        nameLabel.text = name
        setsLabel.text = "\(setsCount) 세트"
    }
}


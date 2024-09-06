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
                        exerciseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
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
    
    private lazy var bodyPartLabel: UILabel = {
        let label = UILabel()
        label.text = "삼두"
        label.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = UIColor(named: "Color5A5A5A")
        view.progressTintColor = UIColor(named: "ColorAccent")
        view.progress = 0.5
        // 모서리값 하드코딩 안하는 방법..?
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
        label.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
        label.textColor = .colorBBBDBD
        label.textAlignment = .center
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
        
        contentView.addSubview(bodyPartLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(totalNumberPerBodyPartLabel)
        contentView.addSubview(foldingImage)
        

        
        bodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        totalNumberPerBodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        foldingImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        exerciseStackView.axis = .vertical
        exerciseStackView.alignment = .leading
        exerciseStackView.distribution = .equalSpacing
        exerciseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            bodyPartLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            bodyPartLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            bodyPartLabel.widthAnchor.constraint(equalToConstant: 68),
            
            progressView.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: bodyPartLabel.trailingAnchor, constant: 12),
            progressView.widthAnchor.constraint(equalToConstant: 130),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            
            totalNumberPerBodyPartLabel.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            totalNumberPerBodyPartLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 14),
            totalNumberPerBodyPartLabel.widthAnchor.constraint(equalToConstant: 50),
            
            foldingImage.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            foldingImage.leadingAnchor.constraint(equalTo: totalNumberPerBodyPartLabel.trailingAnchor, constant: 14),
            foldingImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            
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
    
    func configureCell(with data: ReportBodyPartData, at indexPath: IndexPath, maxTotalSets: Int) {
        
        bodyPartLabel.text = data.bodyPart
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
            exerciseView.configure(index: index , name: exercise.name, setsCount: exercise.setsCount)
            exerciseStackView.addArrangedSubview(exerciseView)
            index += 1
        }
        
        self.indexPath = indexPath
        isStackViewVisibility = data.isStackViewVisible
        
    }
}

class HorizontalDetailStackView: UIView {
    
    private let indexLabel = UILabel()
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
        indexLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        indexLabel.textColor = .white
        
        nameLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        nameLabel.textColor = .white
        
        setsLabel.font = UIFont.font(.pretendardMedium, ofSize: 14)
        setsLabel.textColor = .white
        setsLabel.textAlignment = .right
    }
    
    
    private func setupView() {
        
        changeLabelFontAndColor()
        
        indexLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        setsLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        indexLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        
        stackView.addArrangedSubview(indexLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(setsLabel)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indexLabel.widthAnchor.constraint(equalToConstant: 30), // indexLabel 고정 넓이
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            setsLabel.widthAnchor.constraint(equalToConstant: 60), // setsLabel 고정 넓이
            setsLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
            // nameLabel은 비율에 따라 자동으로 늘어남
        ])
        
    }
    
    func configure(index: Int, name: String, setsCount: Int) {
        indexLabel.text = "\(index)."
        nameLabel.text = name
        setsLabel.text = "\(setsCount) 세트"
    }
}


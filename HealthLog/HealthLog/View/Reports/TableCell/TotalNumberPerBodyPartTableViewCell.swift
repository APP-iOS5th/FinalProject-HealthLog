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
    private var toggleVisibilityAction: ((IndexPath) -> Void)?
    
    private let exerciseStackView = UIStackView()
    private let bodyPartLabel = UILabel()
    private let progressView = UIProgressView()
    private let totalNumberPerBodyPartLabel = UILabel()
    private let foldingImage = UIImageView()
    
    private var isStackViewVisibility = true {
        didSet {
            if isStackViewVisibility {
                if exerciseStackView.superview == nil {
                    contentView.addSubview(exerciseStackView)
                    NSLayoutConstraint.activate([
                        exerciseStackView.topAnchor.constraint(equalTo: bodyPartLabel.bottomAnchor, constant: 8),
                        exerciseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                        exerciseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        exerciseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
                    ])
                }
            } else {
                exerciseStackView.removeFromSuperview()
            }
            
            
            if let tableView = superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
        }
    }
    
    func setupComponent() {
        bodyPartLabel.text = "삼두"
        bodyPartLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
        bodyPartLabel.textColor = .white
        
        progressView.trackTintColor = UIColor(named: "Color5A5A5A")
        progressView.progressTintColor = UIColor(named: "ColorAccent")
        progressView.progress = 0.5
        progressView.layer.cornerRadius = 5
        progressView.clipsToBounds = true
        
        progressView.layer.sublayers![1].cornerRadius = 5
        progressView.subviews[1].clipsToBounds = true
        
        totalNumberPerBodyPartLabel.text = "27세트"
        totalNumberPerBodyPartLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
        totalNumberPerBodyPartLabel.textColor = .white
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .black)
        // cell 클릭시 아래 이름 변경
        let symbolName = isStackViewVisibility ? "chevron.up" : "chevron.down"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        foldingImage.image = symbol
        foldingImage.tintColor = .white
        foldingImage.contentMode = .scaleAspectFit
        
        contentView.addSubview(bodyPartLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(totalNumberPerBodyPartLabel)
        contentView.addSubview(foldingImage)
        
    }
    
//    private lazy var bodyPartLabel: UILabel = {
//        let label = UILabel()
//        label.text = "삼두"
//        label.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
//        label.textColor = .white
//        return label
//    }()
    
//    private lazy var progressView: UIProgressView = {
//        let view = UIProgressView()
//        view.trackTintColor = UIColor(named: "Color5A5A5A")
//        view.progressTintColor = UIColor(named: "ColorAccent")
//        view.progress = 0.5
//        // 모서리값 하드코딩 안하는 방법..?
//        view.layer.cornerRadius = 5
//        view.clipsToBounds = true
//        
//        // 안쪽 게이지 둥글게
//        view.layer.sublayers![1].cornerRadius = 5
//        view.subviews[1].clipsToBounds = true
//        
//        return view
//    }()
    
//    private lazy var totalNumberPerBodyPartLabel: UILabel = {
//        let label = UILabel()
//        label.text = "27세트"
//        label.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
//        label.textColor = .white
//        return label
//    }()
    
//    private lazy var foldingImage: UIImageView = {
//        let imageView = UIImageView()
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .black)
//        // cell 클릭시 아래 이름 변경
//        var symbolName = isStackViewVisibility ? "chevron.up" : "chevron.down"
//        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
//        
//        imageView.image = symbol
//        imageView.tintColor = .white
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
//    private lazy var exerciseStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
////        stackView.alignment = .leading
//        stackView.distribution = .equalSpacing
//        return stackView
//    }()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupComponent()
        
        
        // detailView 작업
        contentView.addSubview(exerciseStackView)

        
        bodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        totalNumberPerBodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        foldingImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        exerciseStackView.axis = .vertical
        //        exercisesStackView.spacing = 12
        exerciseStackView.alignment = .leading
        exerciseStackView.distribution = .equalSpacing
        exerciseStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            bodyPartLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bodyPartLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            
            progressView.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
            progressView.widthAnchor.constraint(equalToConstant: 158),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            
            totalNumberPerBodyPartLabel.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            totalNumberPerBodyPartLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 14),
            
            foldingImage.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            foldingImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleStackViewVisibility() {
        isStackViewVisibility.toggle()
    }
    
    func configureCell(with data: ReportBodyPartData, at indexPath: IndexPath, toggleVisibilityAction: @escaping (IndexPath) -> Void ) {
        
        bodyPartLabel.text = data.bodyPart
        totalNumberPerBodyPartLabel.text = "\(data.totalSets)세트"
        // 추후 최대 값에 맞출 예정
        progressView.progress = Float(data.totalSets) / 100.0
        
        exerciseStackView.arrangedSubviews.forEach {$0.removeFromSuperview() }
        
        var index = 1
        
        for exercise in data.exercises {
            let exerciseView = HorizontalDetailStackView()
            exerciseView.configure(index: index , name: exercise.name, setsCount: exercise.setsCount)
            exerciseStackView.addArrangedSubview(exerciseView)
            index += 1
        }
        
        self.indexPath = indexPath
        self.toggleVisibilityAction = toggleVisibilityAction
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
    
    private func setupView() {
        
        indexLabel.textColor = .white
        nameLabel.textColor = .white
        setsLabel.textColor = .white
        
        
        stackView.axis = .horizontal
//        stackView.alignment = .fill
        stackView.spacing = 10
        
        stackView.addArrangedSubview(indexLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(setsLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    func configure(index: Int, name: String, setsCount: Int) {
        indexLabel.text = "\(index)."
        nameLabel.text = name
        setsLabel.text = "\(setsCount) 세트"
    }
}


//
//  TotalNumberPerBodyPartTableViewCell.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class TotalNumberPerBodyPartTableViewCell: UITableViewCell {
    
    private lazy var bodyPartLabel: UILabel = {
        let label = UILabel()
        label.text = "삼두"
        label.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
        label.textColor = .white
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
        label.textColor = .white
        return label
    }()
    
    private lazy var foldingImage: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .black)
        // cell 클릭시 아래 이름 변경
        let symbolName = "chevron.down"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        
        imageView.image = symbol
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var detailView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.isHidden = true
        
        let label1 = UILabel()
        label1.text = "test label 1"
        let label2 = UILabel()
        label2.text = "test label 2"
        
        
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)

        
        return stackView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bodyPartLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(totalNumberPerBodyPartLabel)
        contentView.addSubview(foldingImage)
        
        // detailView 작업
        contentView.addSubview(detailView)
        
        bodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        totalNumberPerBodyPartLabel.translatesAutoresizingMaskIntoConstraints = false
        foldingImage.translatesAutoresizingMaskIntoConstraints = false
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bodyPartLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bodyPartLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            
            progressView.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 82),
            progressView.widthAnchor.constraint(equalToConstant: 158),
            progressView.heightAnchor.constraint(equalToConstant: 10),
            
            totalNumberPerBodyPartLabel.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            totalNumberPerBodyPartLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 14),
            
            foldingImage.centerYAnchor.constraint(equalTo: bodyPartLabel.centerYAnchor),
            foldingImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            
            detailView.topAnchor.constraint(equalTo: bodyPartLabel.bottomAnchor, constant: 13),
            detailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
            
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

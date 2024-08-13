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
        return view
    }()
    
    private lazy var totalNumberPerBodyPartLabel: UILabel = {
        let label = UILabel()
        label.text = "27세트"
        label.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var foldingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
        config.image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
        config.baseForegroundColor = .white
        button.configuration = config
        button.addAction(UIAction { _ in
            print("did tap foldingbutton")
                                     
        }, for: .touchUpInside)
        
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

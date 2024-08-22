//
//  SearchBodyPartButton.swift
//  HealthLog
//
//  Created by user on 8/22/24.
//

import Combine
import UIKit

class SearchBodyPartButton: UIButton {
    
    private var cancellables = Set<AnyCancellable>()
    let bodypartOption: BodyPartOption
    
    override var isSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    
    init(bodypartOption: BodyPartOption, frame: CGRect = .zero) {
        self.bodypartOption = bodypartOption
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(bodypart:frame:) instead.")
    }
    
    private func setup() {
        setTitle(bodypartOption.name, for: .normal)
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .colorPrimary
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .large
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration = buttonConfig
        titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
    }
    
    private func updateButtonAppearance() {
        if isSelected {
            configuration?.baseBackgroundColor = .colorAccent
        } else {
            configuration?.baseBackgroundColor = .colorPrimary
        }
    }
}


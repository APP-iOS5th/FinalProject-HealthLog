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
    
    // 선택값 변경때마다, 버튼색 변경
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
        setTitle(bodypartOption.name + "", for: .normal)
        titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .colorPrimary
        buttonConfig.baseForegroundColor = .white
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 8, leading: 8, bottom: 8, trailing: 8)
        configuration = buttonConfig
    }
    
    private func updateButtonAppearance() {
        if isSelected {
            configuration?.baseBackgroundColor = .colorAccent
        } else {
            configuration?.baseBackgroundColor = .colorPrimary
        }
    }
}


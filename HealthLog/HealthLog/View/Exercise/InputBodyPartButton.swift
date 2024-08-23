//
//  CustomBodyPartButton.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/20/24.
//

import Combine
import UIKit

class InputBodyPartButton: UIButton {
    
    let bodypart: BodyPart
    private let buttonSubject = PassthroughSubject<InputBodyPartButton, Never>()
    var buttonPublisher: AnyPublisher<InputBodyPartButton, Never> {
        buttonSubject.eraseToAnyPublisher()
    }
    
    override var isSelected: Bool {
        didSet {
            updateButtonAppearance()
            buttonSubject.send(self)
        }
    }
    
    init(bodypart: BodyPart, frame: CGRect = .zero) {
        self.bodypart = bodypart
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(bodypart:frame:) instead.")
    }
    
    private func setup() {
        setTitle(bodypart.rawValue, for: .normal)
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = .colorPrimary
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .large
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration = buttonConfig
        titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        isSelected.toggle()
    }
    
    private func updateButtonAppearance() {
        if isSelected {
            configuration?.baseBackgroundColor = .colorAccent
        } else {
            configuration?.baseBackgroundColor = .colorPrimary
        }
    }
}

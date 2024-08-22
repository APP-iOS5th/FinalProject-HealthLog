//
//  SearchBodyPartStackView.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/22/24.
//
//

import UIKit
import Combine

class SearchBodyPartStackView: UIStackView {
    
    // MARK: - Properties
    
    var bodypartButtonList: [SearchBodyPartButton] = []
    var currentBodyPartOption: BodyPartOption = .all
    private let bodyPartOptionSubject = PassthroughSubject<BodyPartOption, Never>()
    var bodyPartOptionPublisher: AnyPublisher<BodyPartOption, Never> {
        bodyPartOptionSubject.eraseToAnyPublisher()
    }
    
    private var currentRow: UIStackView!
    private var currentButton: SearchBodyPartButton!
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setup()
        addButtonsToStackView()
        deleteCurrentProperties()
        bodypartButtonList[0].isSelected = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func stackContentHidden (isHidden: Bool) {
        arrangedSubviews.forEach { $0.isHidden = isHidden }
        isLayoutMarginsRelativeArrangement = !isHidden
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        axis = .vertical
        spacing = 10
        distribution = .equalSpacing
        alignment = .leading
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    private func addButtonsToStackView() {
        currentRow = RowStackView()
        self.addArrangedSubview(currentRow)
        
        for bodypartOption in BodyPartOption.allCases {
            currentButton = SearchBodyPartButton(bodypartOption: bodypartOption)
            currentButton.addTarget(
                self, action: #selector(buttonTapped(_:)),
                for: .touchUpInside)
            
            let width = calculatorButtonAddAfterWidth()
            checkCreateAfterRow(buttonAddAfterWidth: width)
            
            bodypartButtonList.append(currentButton)
            currentRow.addArrangedSubview(currentButton)
        }
    }
    
    private func deleteCurrentProperties() {
        currentRow = nil
        currentButton = nil
    }
    
    @objc private func buttonTapped(_ targetButton: SearchBodyPartButton)  {
        bodypartButtonList.forEach { $0.isSelected = false }
        targetButton.isSelected = true
        
        currentBodyPartOption = targetButton.bodypartOption
        bodyPartOptionSubject.send(currentBodyPartOption)
        print(currentBodyPartOption)
    }
    
    // MARK: - Sub Private Methods
    
    private func calculatorButtonAddAfterWidth() -> CGFloat {
        let allRowButtonWidth = currentRow
            .arrangedSubviews.reduce(0, { sum, button in
                sum + button.intrinsicContentSize.width +
                currentRow.spacing
            })
        return allRowButtonWidth + currentButton.intrinsicContentSize.width
    }
    
    private func checkCreateAfterRow(buttonAddAfterWidth: CGFloat) {
        if buttonAddAfterWidth > UIScreen.main.bounds.width - 30 {
            currentRow = RowStackView()
            addArrangedSubview(currentRow)
        }
    }
}


// MARK: - Sub UI
private class RowStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .horizontal
        spacing = 5
        distribution = .fillProportionally
        alignment = .center
    }
}

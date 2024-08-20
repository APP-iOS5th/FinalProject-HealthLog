//
//  CustomBodyPartStackView.swift
//  HealthLog
//
//  Created by user on 8/20/24.
//

import UIKit

class CustomBodyPartButtonStackView: UIStackView {
    
    var bodypartButtonList: [UIButton] = []

    private var currentRow: UIStackView!
    private var currentButton: UIButton!
    
    init() {
        super.init(frame: .zero)
        setup()
        addButtonsToStackView()
        deleteCurrentProperties()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    private func setup() {
        axis = .vertical
        spacing = 10
        distribution = .equalSpacing
        alignment = .leading
    }

    private func addButtonsToStackView() {
        currentRow = RowStackView()
        self.addArrangedSubview(currentRow)
        
        for bodyPart in BodyPart.allCases {
            currentButton = CustomBodyPartButton()
            currentButton.setTitle(bodyPart.rawValue, for: .normal)
            
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
    
    // MARK: - Sub Func
    
    private func calculatorButtonAddAfterWidth() -> CGFloat {
        let allRowButtonWidth = currentRow
            .arrangedSubviews.reduce(0, { sum, button in
                sum + button.intrinsicContentSize.width +
                currentRow.spacing
            })
        return allRowButtonWidth + currentButton.intrinsicContentSize.width
    }
    
    private func checkCreateAfterRow(buttonAddAfterWidth: CGFloat) {
        if buttonAddAfterWidth > UIScreen.main.bounds.width {
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

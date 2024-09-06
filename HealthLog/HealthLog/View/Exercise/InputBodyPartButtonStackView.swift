//
//  InputBodyPartButtonStackView.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/20/24.
//

import UIKit

class InputBodyPartButtonStackView: UIStackView {
    
    var bodypartButtonList: [InputBodyPartButton] = []

    private var currentRow: UIStackView!
    private var currentButton: InputBodyPartButton!
    
    init() {
        super.init(frame: .zero)
        setup()
        addButtonsToStackView()
        deleteCurrentProperties()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
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
            currentButton = InputBodyPartButton(bodypart: bodyPart)
            
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
    
    // MARK: - Sub Methods
    
    private func calculatorButtonAddAfterWidth() -> CGFloat {
        let allRowButtonWidth = currentRow
            .arrangedSubviews.reduce(0, { sum, button in
                sum + button.intrinsicContentSize.width +
                currentRow.spacing
            })
        return allRowButtonWidth + currentButton.intrinsicContentSize.width
    }
    
    private func checkCreateAfterRow(buttonAddAfterWidth: CGFloat) {
        if buttonAddAfterWidth > UIScreen.main.bounds.width - 34 {
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

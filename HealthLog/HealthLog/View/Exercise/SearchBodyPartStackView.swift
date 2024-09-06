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
    
    // 외부에서 버튼리스트에 접근 하기위한 변수
    var bodypartButtonList: [SearchBodyPartButton] = []
    
    // 현재 선택된 BodyPartOption
    var currentBodyPartOption: BodyPartOption = .all
    
    // (Combine) .send를 통해 BodyPartOption을 방출
    private let bodyPartOptionSubject = PassthroughSubject<BodyPartOption, Never>()
    
    // (Combine) bodyPartOptionSubject를 외부에서 구독
    var bodyPartOptionPublisher: AnyPublisher<BodyPartOption, Never> {
        bodyPartOptionSubject.eraseToAnyPublisher()
    }
    
    // 스택뷰 안쪽 생성 작업때 쓸 현재상태 변수
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
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 13, right: 0)
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
//        print(currentBodyPartOption)
    }
    
    // MARK: - Sub Private Methods
    
    // 현재 버튼들이 포함된 Row(버튼 가로줄)의 가로폭 계산
    private func calculatorButtonAddAfterWidth() -> CGFloat {
        let allRowButtonWidth = currentRow
            .arrangedSubviews.reduce(0, { sum, button in
                sum + button.intrinsicContentSize.width +
                currentRow.spacing
            })
        return allRowButtonWidth + currentButton.intrinsicContentSize.width
    }
    
    // 가로폭이 넘쳤나 확인 후, 새로운 Row(버튼 가로줄) 생성
    private func checkCreateAfterRow(buttonAddAfterWidth: CGFloat) {
        if buttonAddAfterWidth > UIScreen.main.bounds.width - 26 {
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

//
//  WeightRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class WeightRecordViewController: UIViewController {

    private lazy var inbodyinfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인바디 정보 입력", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .colorSecondary
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(inputModalView), for: .touchUpInside)
        
        // 커스텀 폰트 적용
        let customfont = UIFont.font(.pretendardSemiBold, ofSize: 18)
        button.titleLabel?.font = customfont
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        //배경색 변경
        view.backgroundColor = UIColor(named: "ColorPrimary")
        
        // UI에 추가
        view.addSubview(inbodyinfoButton)
        
        // Auto Layout 설정
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            inbodyinfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inbodyinfoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inbodyinfoButton.widthAnchor.constraint(equalToConstant: 345),
            inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func inputModalView() {
        let vc = InputModalViewController()
        vc.modalPresentationStyle = .formSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]  // 모달 크기 지정
            sheet.prefersGrabberVisible = true  // 시트 상단에 그래버 표시
            sheet.selectedDetentIdentifier = .medium  // 처음 크기 지정
            sheet.largestUndimmedDetentIdentifier = .large  //뒷 배경 흐리게 적용이 안됨
            sheet.preferredCornerRadius = 32
        }
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - ModalViewController
class InputModalViewController: UIViewController {
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
       return button
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인바디 정보 입력"
        label.textColor = .white
        label.font = UIFont.font(.pretendardBold, ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private func createInuptStack(title: String) -> UIStackView {
     let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 16)

     let numbertextField = UITextField()
        numbertextField.backgroundColor = .color767676   // 임시로 색상 바꿈 기존 2E2E2E
        numbertextField.layer.cornerRadius = 12
        numbertextField.keyboardType = .numberPad  // 키보드패드 숫자패드로 변경
        
     let unitLabel = UILabel()
        unitLabel.text = "Kg"
        unitLabel.textColor = .white
        unitLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        
     let stack = UIStackView(arrangedSubviews: [titleLabel, numbertextField, unitLabel])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

     return stack
    }
    
    private lazy var weightStack = createInuptStack(title: "몸무게")
    private lazy var musclesStack = createInuptStack(title: "골격근량")
    private lazy var fatStack = createInuptStack(title: "체지방")
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "*당일 마지막 기록으로만 적용됩니다"
        label.textColor = .systemGray     // 임시로 색상 정함
        label.font = UIFont.font(.pretendardRegular, ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // 배경색
        view.backgroundColor = .colorSecondary  // 잘 안보여서 임시로 색상 바꿈 기존 1E1E1E
        
        // UI에 추가
        view.addSubview(cancelButton)
        view.addSubview(completeButton)
        view.addSubview(titleLabel)
        view.addSubview(weightStack)
        view.addSubview(musclesStack)
        view.addSubview(fatStack)
        view.addSubview(noteLabel)

        
        // Auto Layout 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        weightStack.translatesAutoresizingMaskIntoConstraints = false
        musclesStack.translatesAutoresizingMaskIntoConstraints = false
        fatStack.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            
            weightStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            weightStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            weightStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
           
            musclesStack.topAnchor.constraint(equalTo: weightStack.bottomAnchor, constant: 20),
            musclesStack.leadingAnchor.constraint(equalTo: weightStack.leadingAnchor),
            musclesStack.trailingAnchor.constraint(equalTo: weightStack.trailingAnchor),
           
            fatStack.topAnchor.constraint(equalTo: musclesStack.bottomAnchor, constant: 20),
            fatStack.leadingAnchor.constraint(equalTo: weightStack.leadingAnchor),
            fatStack.trailingAnchor.constraint(equalTo: weightStack.trailingAnchor),
           
            noteLabel.topAnchor.constraint(equalTo: fatStack.bottomAnchor, constant: 26),
            noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    

}

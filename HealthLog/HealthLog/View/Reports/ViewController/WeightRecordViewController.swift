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
    
    private lazy var weightBox = InfoBox(title: "몸무게", value: "84", unit: "kg")
    private lazy var musclesBox = InfoBox(title: "골격근량", value: "84", unit: "kg")  // 근골격량 or 골격근량
    private lazy var fatBox = InfoBox(title: "체지방률", value: "84", unit: "%")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        //배경색 변경
        view.backgroundColor = UIColor(named: "ColorPrimary")
        
        // UI에 추가
        view.addSubview(inbodyinfoButton)
        view.addSubview(weightBox)
        view.addSubview(musclesBox)
        view.addSubview(fatBox)
        
        // Auto Layout 설정
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false
        weightBox.translatesAutoresizingMaskIntoConstraints = false
        musclesBox.translatesAutoresizingMaskIntoConstraints = false
        fatBox.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            inbodyinfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inbodyinfoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inbodyinfoButton.widthAnchor.constraint(equalToConstant: 345),
            inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44),
            
            weightBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            weightBox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightBox.widthAnchor.constraint(equalToConstant: 94),
            weightBox.heightAnchor.constraint(equalToConstant: 88),
            
            musclesBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            musclesBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musclesBox.widthAnchor.constraint(equalToConstant: 94),
            musclesBox.heightAnchor.constraint(equalToConstant: 88),
            
            fatBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            fatBox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fatBox.widthAnchor.constraint(equalToConstant: 94),
            fatBox.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    // 인바디 정보 박스
    private func InfoBox(title: String, value: String, unit: String) -> UIView {
       let boxView = UIView()
       boxView.backgroundColor = .color2F2F2F
       boxView.layer.cornerRadius = 7
       
       let titleLabel = UILabel()
       titleLabel.text = title
       titleLabel.textColor = .white
       titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
       titleLabel.textAlignment = .center
       
       let dividerView = UIView()
       dividerView.backgroundColor = .color3E3E3E
    
       let valueLabel = UILabel()
       valueLabel.text = value
       valueLabel.textColor = .white
       valueLabel.font = UIFont.font(.pretendardBold, ofSize: 25)
       valueLabel.textAlignment = .center
       
       let unitLabel = UILabel()
       unitLabel.text = unit
       unitLabel.textColor = .white
       unitLabel.font = UIFont.font(.pretendardRegular, ofSize: 12)
       unitLabel.textAlignment = .center
        
       // boxView에 추가
       boxView.addSubview(titleLabel)
       boxView.addSubview(dividerView)
       boxView.addSubview(valueLabel)
       boxView.addSubview(unitLabel)
       
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
       dividerView.translatesAutoresizingMaskIntoConstraints = false
       valueLabel.translatesAutoresizingMaskIntoConstraints = false
       unitLabel.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 13),
           titleLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
           
           dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
           dividerView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 8),
           dividerView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -8),
           dividerView.heightAnchor.constraint(equalToConstant: 1),
           
           valueLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8),
           valueLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
           
           unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 2),
           unitLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -3),
       ])
       
       return boxView
   }
    
    // MARK: - Actions
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
class InputModalViewController: UIViewController, UITextFieldDelegate {
    
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
    
    private lazy var weightView = createInputView(title: "몸무게", unit: "Kg")
    private lazy var musclesView = createInputView(title: "골격근량", unit: "Kg")
    private lazy var fatView = createInputView(title: "체지방률", unit: "%")
    
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
        view.backgroundColor = .color1E1E1E
        
        // UI에 추가
        view.addSubview(cancelButton)
        view.addSubview(completeButton)
        view.addSubview(titleLabel)
        view.addSubview(weightView)
        view.addSubview(musclesView)
        view.addSubview(fatView)
        view.addSubview(noteLabel)
        
        // Auto Layout 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        weightView.translatesAutoresizingMaskIntoConstraints = false
        musclesView.translatesAutoresizingMaskIntoConstraints = false
        fatView.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            
            weightView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            weightView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            weightView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
 
            musclesView.topAnchor.constraint(equalTo: weightView.bottomAnchor, constant: 20),
            musclesView.leadingAnchor.constraint(equalTo: weightView.leadingAnchor),
            musclesView.trailingAnchor.constraint(equalTo: weightView.trailingAnchor),

            fatView.topAnchor.constraint(equalTo: musclesView.bottomAnchor, constant: 20),
            fatView.leadingAnchor.constraint(equalTo: weightView.leadingAnchor),
            fatView.trailingAnchor.constraint(equalTo: weightView.trailingAnchor),

            noteLabel.topAnchor.constraint(equalTo: fatView.bottomAnchor, constant: 26),
            noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
    
    // 스택뷰에서 텍스트필드 값만 huggingPriority주고 싶었지만 원하는 대로 잘 안되서 UIView로 가야하나 고민이 됩니다. -> UIView로 변경
    private func createInputView(title: String, unit: String) -> UIView {
        let containerView = UIView()

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 16)

        let numberTextField = UITextField()
        numberTextField.backgroundColor = .color2F2F2F
        numberTextField.layer.cornerRadius = 12
        numberTextField.keyboardType = .numberPad
        numberTextField.textColor = .white
        numberTextField.textAlignment = .left
        
        // Placeholder 폰트, 색상 변경
        numberTextField.attributedPlaceholder = NSAttributedString(
            string: "-",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                NSAttributedString.Key.font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]
        )
        
        // textfield delegate 설정
        numberTextField.delegate = self
        
        let unitLabel = UILabel()
        unitLabel.text = unit
        unitLabel.textColor = .white
        unitLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        
        // containerView에 추가
        containerView.addSubview(titleLabel)
        containerView.addSubview(numberTextField)
        containerView.addSubview(unitLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTextField.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            numberTextField.leadingAnchor.constraint(equalTo: unitLabel.trailingAnchor, constant: -220),
            numberTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            numberTextField.widthAnchor.constraint(equalToConstant: 187),
            numberTextField.heightAnchor.constraint(equalToConstant: 44),

            unitLabel.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            unitLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            unitLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        return containerView
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func completeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 3
        }
    
}

//
//  WeightRecordModalViewController.swift
//  HealthLog
//
//  Created by 김소희 on 8/23/24.
//

import UIKit

class WeightRecordModalViewController: UIViewController, UITextFieldDelegate {
    private let realm = RealmManager.shared.realm
    
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

    
    // 텍스트 필드 입력값을 저장할 변수
    private var weightTextField: UITextField?
    private var musclesTextField: UITextField?
    private var fatTextField: UITextField?
    
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
        
        // 나중에 접근할 수 있도록 텍스트 필드를 할당
        weightTextField = weightView.subviews.first(where: { $0 is UITextField }) as? UITextField
        musclesTextField = musclesView.subviews.first(where: { $0 is UITextField }) as? UITextField
        fatTextField = fatView.subviews.first(where: { $0 is UITextField }) as? UITextField
        
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
        numberTextField.textAlignment = .right
        
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
        guard let weightText = weightTextField?.text, let weight = Float(weightText),
              let musclesText = musclesTextField?.text, let muscleMass = Float(musclesText),
              let fatText = fatTextField?.text, let bodyFat = Float(fatText) else {
                 return
             }

             // RealmManager를 사용해 데이터를 Realm에 저장
             RealmManager.shared.addInbody(weight: weight, bodyFat: bodyFat, muscleMass: muscleMass)

        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 3
        }
    
}

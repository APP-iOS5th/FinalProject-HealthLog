//
//  ExerciseAddViewController.swift
//  HealthLog
//
//  Created by user on 8/12/24.
//

import UIKit

class TempViewController: UIViewController {
    
    private let stepperLabel = UILabel()
    private let stepperCountLabel = UILabel()
    private let stepper = UIStepper()
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        // 타이틀 변경
        title = "스텝퍼"
        
        // 배경색 변경
        view.backgroundColor = UIColor(named: "ColorPrimary") // 배경색 테스트
        
        // Stepper 레이블 설정
        stepperLabel.text = "세트 수"
        stepperLabel.textColor = .white
        stepperLabel.font = UIFont(name: "Pretendard-Black", size: 14) //폰트 테스트
        
        // Stepper 카운트 레이블 설정
        stepperCountLabel.text = "4"
        stepperCountLabel.textColor = .white
        stepperCountLabel.font = UIFont(name: "Pretendard-Black", size: 14) //폰트 테스트
        
        // Stepper 설정
        stepper.minimumValue = 1  // 최소값
        stepper.maximumValue = 6  // 최대값
        stepper.value = 4 // 기본값
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.layer.cornerRadius = 8
        stepper.backgroundColor = UIColor(named: "ColorAccent")  // 색 적용 테스트
        
        // 컨테이너 뷰 설정
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        // 컨테이너 뷰에 추가
        containerView.addSubview(stepperLabel)
        containerView.addSubview(stepperCountLabel)
        containerView.addSubview(stepper)
        
        // 스택뷰 설정
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        
        // UI에 추가
        view.addSubview(containerView)
        view.addSubview(stackView)
        
        // Auto Layout 설정
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperCountLabel.translatesAutoresizingMaskIntoConstraints = false
        stepper.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            stepperLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stepperLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stepperCountLabel.leadingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -20),
            stepperCountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stepper.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
        
        updateSetInputs()
        
    }
    
    @objc func stepperValueChanged() {
        let value = Int(stepper.value)
        stepperCountLabel.text = "\(value)"
        updateSetInputs()
    }
    
    func updateSetInputs() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...Int(stepper.value) {
            let setView = createSetInputView(setNumber: i)
            stackView.addArrangedSubview(setView)
        }
    }
    
    // 세트 무게, 횟수 입력 뷰
    func createSetInputView(setNumber: Int) -> UIView {
        let setView = UIView()
        
        let setLabel = UILabel()
        setLabel.text = "세트 \(setNumber)"
        setLabel.textColor = .white
        
        let weightTextField = UITextField()
        weightTextField.backgroundColor = UIColor(named: "ColorASecondary")  // 색 적용 테스트
        weightTextField.attributedPlaceholder = NSAttributedString(
            string: "무게",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )

        let weightLabel = UILabel()
        weightLabel.text = "kg"
        weightLabel.textColor = .white
        
        let repsTextField = UITextField()
        repsTextField.backgroundColor = UIColor(named: "ColorASecondary")  // 색 적용 테스트
        repsTextField.attributedPlaceholder = NSAttributedString(
            string: "횟수",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        let repsLabel = UILabel()
        repsLabel.text = "회"
        repsLabel.textColor = .white
        
        // setView에 추가
        setView.addSubview(setLabel)
        setView.addSubview(weightTextField)
        setView.addSubview(weightLabel)
        setView.addSubview(repsTextField)
        setView.addSubview(repsLabel)

        // Auto Layout 설정
        setLabel.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        repsTextField.translatesAutoresizingMaskIntoConstraints = false
        repsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            setView.heightAnchor.constraint(equalToConstant: 50),

            setLabel.leadingAnchor.constraint(equalTo: setView.leadingAnchor, constant: 8),
            setLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            
            weightTextField.leadingAnchor.constraint(equalTo: setLabel.trailingAnchor, constant: 45),
            weightTextField.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            weightTextField.widthAnchor.constraint(equalToConstant: 60),
            
            weightLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            weightLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            
            repsTextField.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 38),
            repsTextField.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            repsTextField.widthAnchor.constraint(equalToConstant: 60),
            
            repsLabel.leadingAnchor.constraint(equalTo: repsTextField.trailingAnchor, constant: 8),
            repsLabel.centerYAnchor.constraint(equalTo: setView.centerYAnchor),
            repsLabel.trailingAnchor.constraint(equalTo: setView.trailingAnchor, constant: -8)
            
        ])
    
    return setView

    }
}

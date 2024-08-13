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
        stepper.layer.cornerRadius = 8
        stepper.backgroundColor = UIColor(named: "ColorAccent")  // 색 적용 테스트
        
        // 컨테이너 뷰 설정
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        
        // 컨테이너 뷰에 추가
        containerView.addSubview(stepperLabel)
        containerView.addSubview(stepperCountLabel)
        containerView.addSubview(stepper)
        
        // UI에 추가
        view.addSubview(containerView)

        // Auto Layout 설정
        stepperLabel.translatesAutoresizingMaskIntoConstraints = false
        stepperCountLabel.translatesAutoresizingMaskIntoConstraints = false
        stepper.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
        ])
    }
}

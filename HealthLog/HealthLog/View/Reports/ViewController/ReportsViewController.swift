//
//  ReportsViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class ReportsViewController: UIViewController {
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
        
    }()
    
    private lazy var moveToPreviousMonthButton: UIButton = {
        let button = createMonthButton(action: UIAction {[weak self] _ in
            self?.didTapPreviousMonth()
        }, imageName: "chevron.left")
        return button
    }()
    
    private lazy var titleMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "2024년 7월 리포트"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .white
        return label
    }()
    
    
    private lazy var moveToNextMonthButton: UIButton = {
        let button = createMonthButton(action: UIAction {[weak self] _ in
            self?.didTapNextMonth()
        }, imageName: "chevron.right")
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "운동 기록", at: 0, animated: true)
        control.insertSegment(withTitle: "인바디 기록", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        
        
        control.selectedSegmentTintColor = UIColor(named: "ColorAccent")
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        control.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13)
        ], for: .normal)
        
        control.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13)
        ], for: .selected)
        
        
        return control
    }()
    
    let exerciseRecordVC = ExerciseRecordViewController()
    let weightRecordVC = WeightRecordViewController()
    
    var currentVC: UIViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
    
        
        
        titleStackView.addArrangedSubview(moveToPreviousMonthButton)
        titleStackView.addArrangedSubview(titleMonthLabel)
        titleStackView.addArrangedSubview(moveToNextMonthButton)
    
        self.view.addSubview(titleStackView)
        self.view.addSubview(segmentedControl)
        
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            titleStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            
            segmentedControl.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 13),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            
        ])
        //AutoresizingMask 관리
        setTranslatesAutoresizing()
        
        
        let initialViewController = exerciseRecordVC
        addChild(initialViewController)
        initialViewController.didMove(toParent: self)
        currentVC = initialViewController
        
    }
    
    private func createMonthButton(action: UIAction, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: imageName, withConfiguration: symbolConfig)
        config.baseForegroundColor = .white
        button.configuration = config
        
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    // MARK: Set translatesAutoresizingMaskIntoConstraints
    private func setTranslatesAutoresizing() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        moveToPreviousMonthButton.translatesAutoresizingMaskIntoConstraints = false
        titleMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        moveToNextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    
    private func didTapPreviousMonth() {
        print("이전 달로 이동")
        // TODO: 이전 달로 이동 버튼 구현
        
    }
    
    private func didTapNextMonth() {
        print("다음 달로 이동")
        // TODO: 다음 달로 이동 버튼 구현
    }
    
    // MARK: SegmentControl
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        
        let newVC: UIViewController
        if selectedIndex == 0 {
            newVC = exerciseRecordVC
        } else {
            newVC = weightRecordVC
        }
        
        addChild(newVC)
        newVC.didMove(toParent: self)
        currentVC = newVC
        
    }
    
    override func addChild(_ viewController: UIViewController) {
            view.addSubview(viewController.view)
            
            // 레이아웃 설정
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
                viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    

}





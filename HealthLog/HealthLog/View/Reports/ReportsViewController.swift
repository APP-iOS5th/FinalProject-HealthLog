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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        
        titleStackView.addArrangedSubview(moveToPreviousMonthButton)
        titleStackView.addArrangedSubview(titleMonthLabel)
        titleStackView.addArrangedSubview(moveToNextMonthButton)
    
        self.view.addSubview(titleStackView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            titleStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24)
        ])
        
        
        
        setTranslatesAutoresizing()
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
        
    }
    
    
    
    private func didTapPreviousMonth() {
        print("이전 달로 이동")
        // TODO: 이전 달로 이동 버튼 구현
        
    }
    
    private func didTapNextMonth() {
        print("다음 달로 이동")
        // TODO: 다음 달로 이동 버튼 구현
    }
    
    

}





//
//  RoutineAddNameViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/12/24.
//

import UIKit

class RoutineAddNameViewController: UIViewController {

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴 이름을 정해주세요."
        label.font =  UIFont(name: "Pretendard-bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "ColorSecondary")
        // 더 좋은 방법 있으면 수정
        textField.attributedPlaceholder = NSAttributedString(string: "루틴 이름 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        textField.textColor = .white
        return textField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupView()
        
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        
        
        navigationController?.setupBarAppearance()
        self.view.addSubview(textLabel)
        self.view.addSubview(nameTextField)
        self.tabBarController?.tabBar.isHidden = true
        let safeArea = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant:  12),
            self.textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 12),
            self.nameTextField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
            self.nameTextField.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            self.nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 44)
            
        ])
        
        
    }
}

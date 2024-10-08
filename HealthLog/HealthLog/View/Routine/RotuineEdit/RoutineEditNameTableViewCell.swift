//
//  RotineEditNameTableViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 9/6/24.
//

import UIKit

class RoutineEditNameTableViewCell: UITableViewCell {
    
    static let identifier = "RotineEditNameTableViewCell"
    
    lazy var nameVaildLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.font(.pretendardRegular, ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.isHidden = false
        label.text = " "
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .color2F2F2F
        // 더 좋은 방법 있으면 수정
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: "루틴 이름 입력", attributes: [NSAttributedString.Key.foregroundColor :  UIColor.systemGray, NSAttributedString.Key.font: UIFont.font(.pretendardRegular, ofSize: 14)])
        textField.textColor = .white
        textField.font = UIFont.font(.pretendardRegular, ofSize: 14)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        self.backgroundColor = .clear
        self.contentView.addSubview(nameTextField)
        self.contentView.addSubview(nameVaildLabel)
        
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        
        NSLayoutConstraint.activate([
            self.nameTextField.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            self.nameVaildLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor,constant: 3),
            self.nameVaildLabel.leadingAnchor.constraint(equalTo: self.nameTextField.leadingAnchor),
            self.nameVaildLabel.trailingAnchor.constraint(equalTo: self.nameTextField.trailingAnchor),
            self.nameVaildLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            
        ])
        
    }
    func isValidhidden(isValid: Bool) {
        self.nameVaildLabel.isHidden = isValid
    }
    
    func isValidText(text: String, color: UIColor) {
        self.nameVaildLabel.text = text
        self.nameVaildLabel.textColor = color
    }
}

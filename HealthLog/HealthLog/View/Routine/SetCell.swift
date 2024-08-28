//
//  RoutineExerciseStepperCollectionViewCell.swift
//  HealthLog
//
//  Created by 어재선 on 8/22/24.
//

import UIKit
import Combine

class SetCell: UICollectionViewCell {
    static let identifier = "SetCell"
    
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var setNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weightTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "무게", attributes: [NSAttributedString.Key.foregroundColor :  UIColor.systemGray])
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        
        textField.borderStyle = .none
        textField.backgroundColor = .color2F2F2F
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private lazy var weightTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kg"
        label.textColor = .white
        label.font =  UIFont.font(.pretendardMedium, ofSize: 14)
        return label
    }()
    
    private lazy var weightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weightTextField,weightTextLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()

    
    
    private lazy var repsTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: "횟수", attributes: [NSAttributedString.Key.foregroundColor :  UIColor.systemGray])
        textField.backgroundColor = .color2F2F2F

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
 
    
    private lazy var repsTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "회"
        label.textColor = .white
        label.font =  UIFont.font(.pretendardMedium, ofSize: 14)
        return label
    }()
    private lazy var repsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [repsTextField,repsTextLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [setNumberLabel, weightStackView, repsStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.containerStackView)
        NSLayoutConstraint.activate([
           
            self.containerStackView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.containerStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.weightTextField.widthAnchor.constraint(equalToConstant: 58),
            self.weightTextField.heightAnchor.constraint(equalToConstant: 35),
            
            self.repsTextField.widthAnchor.constraint(equalToConstant: 58),
            self.repsTextField.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with set: RoutineExerciseSet ) {
        setNumberLabel.text = "\(set.order) 세트"
        weightTextField.text = set.weight == 0 ? "" : "\(set.weight)"
        repsTextField.text = set.reps == 0 ? "" : "\(set.reps)"
        
        // MARK: Combine
        
        // 셀의 모든 구독을 해제 (이 셀에 걸려있는거 모두 해제이므로 주의)
        cancellables.removeAll()
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: weightTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("weightTextField combine change")
                set.weight = Int(text) ?? 0
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: repsTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("repsTextField combine change")
                set.reps = Int(text) ?? 0
            }
            .store(in: &cancellables)
    }
}

//
//  RoutineAddNameViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/12/24.
//

import UIKit
import Combine

class RoutineAddNameViewController: UIViewController {
    
    var viewModel = RoutineViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(named: "ColorSecondary")
        // 더 좋은 방법 있으면 수정
        textField.attributedPlaceholder = NSAttributedString(string: "루틴 이름 입력", attributes: [NSAttributedString.Key.foregroundColor :  UIColor.systemGray])
        textField.textColor = .white
        textField.font = UIFont.font(.pretendardMedium, ofSize: 14)
        return textField
        
    }()
    
    private lazy var subTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "확인"
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 0, bottom: 17, trailing: 0)
        let button = UIButton(configuration: configuration,
                              primaryAction: UIAction { _ in
            let routineAddExerciseViewController = RoutineAddExerciseViewController()
            self.navigationController?.pushViewController(routineAddExerciseViewController, animated: true)
            print("확인 버튼 눌림")
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = UIColor(named: "ColorAccent")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addName")
        
        
        setupUI()
        
        // 텍스트필드에서 나가는 이벤트를
        // 뷰모델의 프로퍼티가 구독
        nameTextField
            .textPublisher
            .print()
            // 스레드 - 메인에서 받겠다.
            .receive(on: RunLoop.main)
            .assign(to: \.rutineNameinput, on: viewModel)
            .store(in: &cancellables)
        
        // 버튼이 뷰모델의 퍼블리셔를 구독
        viewModel.isMatchNameInput
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: checkButton)
            .store(in: &cancellables)
        
        viewModel.isMatchNameInput
            .print()
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: subTextLabel)
            .store(in: &cancellables)
        
    }
    


    
    func setupUI() {
        self.navigationController?.setupBarAppearance()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "루틴 이름을 정해주세요"
       

        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        
        let backbarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbarButtonItem
        
        navigationController?.setupBarAppearance()
        //MARK: - addSubview
        self.view.addSubview(nameTextField)
        self.view.addSubview(subTextLabel)
        self.view.addSubview(checkButton)
        
        self.tabBarController?.tabBar.isHidden = true
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
           
            
            self.nameTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            self.nameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            self.nameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.nameTextField.heightAnchor.constraint(equalToConstant: 44),
            self.subTextLabel.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 5),
            self.subTextLabel.leadingAnchor.constraint(equalTo: self.nameTextField.leadingAnchor),
            self.checkButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.checkButton.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -30),
            self.checkButton.leadingAnchor.constraint(equalTo: self.nameTextField.leadingAnchor),
            self.checkButton.trailingAnchor.constraint(equalTo: self.nameTextField.trailingAnchor),
            
        ])
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
        // UITextField 가져옴
            .compactMap{ $0.object as? UITextField}
        // String 가져옴
            .map{ $0.text ?? ""}
            .print()
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var isValid: Bool {
        get {
            backgroundColor == UIColor.colorAccent
        }
        
        set {
            backgroundColor = newValue ? .colorAccent : .lightGray
            isEnabled = newValue
            
        }
    }
}

extension UILabel {
    var isValid: Bool {
        get {
            true
        }
        
        set {
            isHidden = newValue 
            textColor = newValue ? .green : .red
            text = newValue ? "사용 가능한 이름입니다." : "이미 존재하는 이름 입니다."
            
        }
    }
}


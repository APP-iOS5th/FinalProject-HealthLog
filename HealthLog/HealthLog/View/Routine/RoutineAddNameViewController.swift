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
    private var isValid: Bool = false
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .color2F2F2F
        // 더 좋은 방법 있으면 수정
        textField.attributedPlaceholder = NSAttributedString(string: "루틴 이름 입력", attributes: [NSAttributedString.Key.foregroundColor :  UIColor.systemGray])
        textField.textColor = .white
        textField.font = UIFont.font(.pretendardRegular, ofSize: 14)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        
        return textField
        
    }()
    
    private lazy var subTextLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.rutineNameConfirmation
        label.font = UIFont.font(.pretendardRegular, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "확인"
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 0, bottom: 17, trailing: 0)
        let button = UIButton(configuration: configuration,
                              primaryAction: UIAction { _ in
            let routineAddExerciseViewController = RoutineAddExerciseViewController(routineName: self.viewModel.rutineNameinput)
            
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
        self.hideKeyBoardWenTappedAround()
        
        setupUI()
        setupObservers()

        
    }
    
    func setupObservers() {
        nameTextField
            .textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.rutineNameinput, on: viewModel)
            .store(in: &cancellables)
        
        
        Publishers.CombineLatest(viewModel.isRoutineNameEmptyPulisher, viewModel.isRoutineNameMatchingPulisher)
                    .map { !$0 && $1 }
                    .receive(on: DispatchQueue.main)
                    .assign(to:\.isValid ,on:checkButton)
                    .store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.isRoutineNameEmptyPulisher, viewModel.isRoutineNameMatchingPulisher)
                    .map { !$0 && $1 }
                    .receive(on: DispatchQueue.main)
                    .assign(to:\.isValid ,on: subTextLabel)
                    .store(in: &cancellables)
        
        Publishers.CombineLatest(viewModel.isRoutineNameEmptyPulisher, viewModel.isRoutineNameMatchingPulisher)
            .map { isRoutineNameEmptyPulisher, isRoutineNameMatchingPulisher in
                if isRoutineNameEmptyPulisher {
                    return ""
                } else if !isRoutineNameMatchingPulisher {
                    return "이미 사용준인 루틴 이름입니다."
                }
                return "사용 가능한 루틴입니다."
            }
            .receive(on: DispatchQueue.main)
            .assign(to:\.validMessage ,on:subTextLabel)
            .store(in: &cancellables)
    }


    
    func setupUI() {
        self.navigationController?.setupBarAppearance()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "루틴 이름을 정해주세요"
        

        self.view.backgroundColor = .color1E1E1E
        
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

extension RoutineAddNameViewController {
    // 키보드 내리기
    func hideKeyBoardWenTappedAround() {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
}


extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
        // UITextField 가져옴
            .compactMap{ $0.object as? UITextField}
        // String 가져옴
            .map{ $0.text ?? ""}
//            .print()
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
    var validMessage: String {
        get {
            ""
        }
        set {
            text = newValue
        }
    }
    
    var isValid: Bool {
        get {
            true
        }
        set {
            textColor = newValue ? .green : .red
        }
    }
    
}

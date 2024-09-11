//
//  SaveRoutineViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/20/24.
//

import UIKit
import RealmSwift

class SaveRoutineViewController: UIViewController {
    private let viewModel = ScheduleViewModel()
    private let schedule: Schedule
    private var existName: Bool = false
    
    init(schedule: Schedule) {
        self.schedule = schedule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont.font(.pretendardMedium, ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont.font(.pretendardMedium, ofSize: 16)
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.text = "루틴 이름"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var routineName: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Pretendard-Regular", size: 20)
        textField.textColor = .white
        textField.backgroundColor = .colorSecondary
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    lazy var notification: UILabel = {
        let label = UILabel()
        label.text = "이미 존재하는 이름입니다."
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set default routine name
        let placeholderText = changeDateToString(schedule.date)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        routineName.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .colorPrimary
        
        container.addArrangedSubview(pageTitle)
        container.addArrangedSubview(routineName)
        
        view.addSubview(container)
        view.addSubview(cancelButton)
        view.addSubview(completeButton)
        routineName.becomeFirstResponder()
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            completeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            pageTitle.heightAnchor.constraint(equalToConstant: 20),
            
            routineName.heightAnchor.constraint(equalToConstant: 44),
            routineName.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            routineName.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            
            container.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 13),
            container.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
        cancelButton.addTarget(self, action: #selector(cancelSave), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(saveRoutine), for: .touchUpInside)
    }
    
    // MARK: - Methods
    @objc private func cancelSave() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveRoutine() {
        let routineText = routineName.text?.isEmpty ?? true ? routineName.placeholder : routineName.text
        
        guard let routineName = routineText else {
            return
        }
        
        existName = viewModel.checkExistRoutineName(routineName)
        
        if existName {
            container.addArrangedSubview(notification)
            let notificationHeightConstraint = notification.heightAnchor.constraint(equalToConstant: 14)
            notificationHeightConstraint.isActive = true
        } else {
            if viewModel.saveRoutineToDatabase(name: routineName, schedule: schedule) {
                existName = false
                let alertController = UIAlertController(title: "루틴 저장 완료", message: "루틴 (\(routineName))이 성공적으로 저장되었습니다.", preferredStyle: .alert)
                present(alertController, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    alertController.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true)
                }
            } else {
                // Handle save error
                let alertController = UIAlertController(title: "저장 실패", message: "루틴을 저장하는 중 오류가 발생했습니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func changeDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date.toKoreanTime())
    }
}

//
//  ExercisesFormViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/17/24.
//

import Combine
import UIKit

class ExercisesEntryViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let entryViewModel: ExerciseEntryViewModel
    private let viewModel: ExerciseViewModel
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let titleTextField = PaddedTextField()
    private let titleDuplicateWarningLabel = UILabel()
    private let titleEmptyWarningLabel = UILabel()
    
    private let bodypartStackView = UIStackView()
    private let bodypartLabel = UILabel()
    private let bodypartButtonStackView = InputBodyPartButtonStackView()
    private let bodypartEmptyWarningLabel = UILabel()
    
    private let recentWeightStackView = UIStackView()
    private let recentWeightLabel = UILabel()
    private let recentWeightTextFieldStackView = UIStackView()
    private let recentWeightTextField = PaddedTextField()
    private let recentWeightKGLabel = UILabel()
    
    private let maxWeightStackView = UIStackView()
    private let maxWeightLabel = UILabel()
    private let maxWeightTextFieldStackView = UIStackView()
    private let maxWeightTextField = PaddedTextField()
    private let maxWeightKGLabel = UILabel()
    
    private let descriptionStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let descriptionTextView = UITextView()
    
    private let imageStackView = UIStackView()
    private let imageLabel = UILabel()
    
    private let deleteButton: UIButton?
    
    // MARK: - Init
    
    init(entryViewModel: ExerciseEntryViewModel) {
        self.entryViewModel = entryViewModel
        self.viewModel = entryViewModel.viewModel
        switch entryViewModel.mode {
            case .add: deleteButton = nil
            case .update: deleteButton = UIButton()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .color1E1E1E
        
        setupNavigationBar()
        setupTitleStackView()
        setupBodypartStackView()
        setupRecentWeightStackView()
        setupMaxWeightStackView()
        setupDescriptionStackView()
        setupImageStackView()
        setupDeleteButton()
        
        setupBindingsUpdateMode()
        setupBindingsData()
        setupBindingsUI()
    }
    
    // MARK: - Setup UI
    
    func setupNavigationBar() {
        switch entryViewModel.mode {
            case .add: title = "운동 추가"
            case .update: title = "운동 수정"
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // MARK: addButton
        let doneButton = UIBarButtonItem(
            title: "완료", style: .done, target: self,
            action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        
        // MARK: backButton
        let backbarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbarButtonItem
        
        // MARK: tabBar
        self.tabBarController?.tabBar.isHidden = true
        
        // MARK: scrollView
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
//        scrollView.contentInset = UIEdgeInsets(
//            top: 10, left: 10, bottom: 10, right: 10)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 8),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -8),
        ])
        
        // MARK: stackView
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .leading
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupTitleStackView() {
        // MARK: titleStackView
        titleStackView.axis = .vertical
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 13
        titleStackView.alignment = .leading
        stackView.addArrangedSubview(titleStackView)
        
        // MARK: titleLabel
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        let titleLabelText = "운동 이름 *"
        let attributedString = NSMutableAttributedString(string: titleLabelText)
        let range = (titleLabelText as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        titleLabel.attributedText = attributedString
        titleStackView.addArrangedSubview(titleLabel)
        
        // MARK: titleTextField
        titleTextField.tag = 1001
        titleTextField.delegate = self
        titleStackView.addArrangedSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            titleTextField.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
        ])

        // MARK: titleDuplicateWarningLabel
        titleDuplicateWarningLabel.text = "이미 존재하는 운동 이름입니다."
        titleDuplicateWarningLabel.numberOfLines = 1
        titleDuplicateWarningLabel.textColor = .red
        titleStackView.addArrangedSubview(titleDuplicateWarningLabel)
        
        // MARK: titleEmptyWarningLabel
        titleEmptyWarningLabel.text = "운동 이름이 비어있습니다."
        titleEmptyWarningLabel.numberOfLines = 1
        titleEmptyWarningLabel.textColor = .red
        titleStackView.addArrangedSubview(titleEmptyWarningLabel)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .color2F2F2F
        titleStackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
        ])
    }
    
    func setupBodypartStackView() {
        // MARK: bodypartStackView
        bodypartStackView.axis = .vertical
        bodypartStackView.distribution = .equalSpacing
        bodypartStackView.spacing = 10
        bodypartStackView.alignment = .leading
        bodypartStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(bodypartStackView)
        
        // MARK: bodypartLabel
        bodypartLabel.textColor = .white
        let bodypartLabelText = "운동 부위 *"
        let attributedString = NSMutableAttributedString(string: bodypartLabelText)
        let range = (bodypartLabelText as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        bodypartLabel.attributedText = attributedString
        bodypartStackView.addArrangedSubview(bodypartLabel)
        
        // MARK: bodypartButtonStackView
        bodypartStackView.addArrangedSubview(bodypartButtonStackView)
        
        // MARK: bodypartEmptyWarningLabel
        bodypartEmptyWarningLabel.text = "운동 부위가 비어있습니다."
        bodypartEmptyWarningLabel.numberOfLines = 1
        bodypartEmptyWarningLabel.textColor = .red
        bodypartStackView.addArrangedSubview(bodypartEmptyWarningLabel)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .color2F2F2F
        bodypartStackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
        ])
    }
    
    func setupRecentWeightStackView() {
        // MARK: recentWeightStackView
        recentWeightStackView.axis = .vertical
        recentWeightStackView.distribution = .equalSpacing
        recentWeightStackView.spacing = 10
        recentWeightStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(recentWeightStackView)
        
        // MARK: recentWeightLabel
        recentWeightLabel.textColor = .white
        recentWeightLabel.text = "최근 무게"
        recentWeightStackView.addArrangedSubview(recentWeightLabel)
        NSLayoutConstraint.activate([
            recentWeightLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            recentWeightLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
        ])
        
        // MARK: recentWeightTextFieldStackView
        recentWeightTextFieldStackView.axis = .horizontal
        recentWeightTextFieldStackView.distribution = .fillEqually
        recentWeightTextFieldStackView.spacing = 10
        recentWeightStackView.addArrangedSubview(recentWeightTextFieldStackView)
        
        // MARK: recentWeightTextField
        recentWeightTextField.tag = 1002
        recentWeightTextField.delegate = self
        recentWeightTextField.textColor = .white
        recentWeightTextField.keyboardType = .numberPad
        recentWeightTextFieldStackView.addArrangedSubview(recentWeightTextField)
        
        // MARK: recentWeightKGLabel
        recentWeightKGLabel.text = "KG"
        recentWeightKGLabel.textColor = .white
        recentWeightTextFieldStackView.addArrangedSubview(recentWeightKGLabel)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .color2F2F2F
        recentWeightStackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
        ])
    }
    
    func setupMaxWeightStackView() {
        // MARK: maxWeightStackView
        maxWeightStackView.axis = .vertical
        maxWeightStackView.distribution = .equalSpacing
        maxWeightStackView.spacing = 10
        maxWeightStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(maxWeightStackView)
        
        // MARK: maxWeightLabel
        maxWeightLabel.textColor = .white
        maxWeightLabel.text = "최대 무게"
        maxWeightStackView.addArrangedSubview(maxWeightLabel)
        NSLayoutConstraint.activate([
            maxWeightLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            maxWeightLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
        ])
        
        // MARK: maxWeightTextFieldStackView
        maxWeightTextFieldStackView.axis = .horizontal
        maxWeightTextFieldStackView.distribution = .fillEqually
        maxWeightTextFieldStackView.spacing = 10
        maxWeightStackView.addArrangedSubview(maxWeightTextFieldStackView)
        
        // MARK: maxWeightTextField
        maxWeightTextField.tag = 1003
        maxWeightTextField.delegate = self
        maxWeightTextField.textColor = .white
        maxWeightTextField.keyboardType = .numberPad
        maxWeightTextFieldStackView.addArrangedSubview(maxWeightTextField)
        
        // MARK: maxWeightKGLabel
        maxWeightKGLabel.text = "KG"
        maxWeightKGLabel.textColor = .white
        maxWeightTextFieldStackView.addArrangedSubview(maxWeightKGLabel)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .color2F2F2F
        maxWeightStackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
        ])
    }
    
    func setupDescriptionStackView() {
        // MARK: descriptionStackView
        descriptionStackView.axis = .vertical
        descriptionStackView.distribution = .equalSpacing
        descriptionStackView.spacing = 10
        descriptionStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(descriptionStackView)
        
        // MARK: descriptionLabel
        descriptionLabel.textColor = .white
        descriptionLabel.text = "운동 설명"
        descriptionStackView.addArrangedSubview(descriptionLabel)
        
        // MARK: descriptionTextView
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = .color2F2F2F
        descriptionTextView.layer.cornerRadius = 12
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont(name: "Pretendard-Medium", size: 16)
        descriptionTextView.textContainerInset = UIEdgeInsets(
            top: 13, left: 13, bottom: 13, right: 13)
        descriptionStackView.addArrangedSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
        ])
        
        let dividerView = UIView()
        dividerView.backgroundColor = .color2F2F2F
        descriptionStackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            dividerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -10),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
        ])
    }
    
    func setupImageStackView() {
        // MARK: ImageStackView
        imageStackView.axis = .vertical
        imageStackView.distribution = .equalSpacing
        imageStackView.spacing = 10
        imageStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(imageStackView)
        
        // MARK: imageLabel
        imageLabel.textColor = .white
        imageLabel.text = "운동 이미지"
        imageStackView.addArrangedSubview(imageLabel)
    }
    
    func setupDeleteButton() {
        guard case .update = entryViewModel.mode else { return }
        guard let deleteButton = deleteButton else { return }
        
        deleteButton.backgroundColor = .color2F2F2F
        deleteButton.tintColor = .red
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.addTarget(
            self, action: #selector(deleteButtonTapped),
            for: .touchUpInside)
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    // MARK: - Setup Binddings
    
    private func setupBindingsData() {
        // MARK: Input titleTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: titleTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print(text)
                print( self.entryViewModel.entryExercise.name)
                self.entryViewModel.entryExercise.name = text
            }
            .store(in: &cancellables)
        
        // MARK: Input bodypartButtonStackView
        // 버튼리스트로 순회 구독. 버튼 터치시 ViewModel에 bodyPart 삽입
        bodypartButtonStackView.bodypartButtonList.forEach { button in
            button.buttonPublisher
                .sink { button in
                    if button.isSelected { // 선택시 삽입
                        self.entryViewModel.entryExercise
                            .bodyParts.append(button.bodypart)
                    } else { // 선택 해제시 제거
                        self.entryViewModel.entryExercise
                            .bodyParts.removeAll { $0 == button.bodypart }
                    }
                    print("\(button.bodypart.rawValue) - \(button.isSelected)")
                }
                .store(in: &cancellables)
        }
        
        // MARK: Input recentWeightTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: recentWeightTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("recentWeightTextField change")
                self.entryViewModel.entryExercise.recentWeight = Int(text) ?? 0
            }
            .store(in: &cancellables)
        
        // MARK: Input maxWeightTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: maxWeightTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
                print("maxWeightTextField change")
                self.entryViewModel.entryExercise.maxWeight = Int(text) ?? 0
            }
            .store(in: &cancellables)
        
        // MARK: Input descriptionTextView
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: descriptionTextView)
            .compactMap { ($0.object as? UITextView)?.text }
            .sink { text in
                print("descriptionTextView change")
                self.entryViewModel.entryExercise.description = text
            }
            .store(in: &cancellables)
        
        // MARK: Input Duplicate ExerciseName Warning
        self.entryViewModel.entryExercise.$hasDuplicateName
            .sink { [weak self] hasDuplicate in
                let label = self?.titleDuplicateWarningLabel
                self?.warningLabelAnimation(label, isWarning: hasDuplicate)
            }
            .store(in: &cancellables)
    }
    
    private func setupBindingsUI() {
        // MARK: UI Empty ExerciseName Warning
        self.entryViewModel.entryExercise.$isNameEmpty
            .sink { [weak self] isEmpty in
                let label = self?.titleEmptyWarningLabel
                self?.warningLabelAnimation(label, isWarning: isEmpty)
            }
            .store(in: &cancellables)
        
        // MARK: UI Empty Bodyparts Warning
        self.entryViewModel.entryExercise.$isBodyPartsEmpty
            .sink { [weak self] isEmpty in
                let label = self?.bodypartEmptyWarningLabel
                self?.warningLabelAnimation(label, isWarning: isEmpty)
            }
            .store(in: &cancellables)
        
        // MARK: UI Validated Exercise Fields - Done Button
        self.entryViewModel.entryExercise.$isValidatedRequiredExerciseFields
            .sink { [weak self] isValidated in
                self?.navigationItem.rightBarButtonItem?
                    .isEnabled = isValidated
            }
            .store(in: &cancellables)
    }
    
    private func setupBindingsUpdateMode() {
        guard case .update(let detailViewModel) = entryViewModel.mode
        else { return }
        
        //
        
        // MARK: UI,Input detail exercise
        detailViewModel.$exercise
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.entryViewModel.entryExercise.name = $0.name
                self?.titleTextField.text = $0.name
                
                $0.bodyParts.forEach { bodypart in
                    self?.bodypartButtonStackView
                        .bodypartButtonList
                        .first(where: { $0.bodypart == bodypart })?
                        .sendActions(for: .touchUpInside)
                }
                
                self?.entryViewModel.entryExercise.recentWeight = $0.recentWeight
                self?.recentWeightTextField.text = String($0.recentWeight)
                
                self?.entryViewModel.entryExercise.maxWeight = $0.maxWeight
                self?.maxWeightTextField.text = String($0.maxWeight)
                
                self?.entryViewModel.entryExercise.description = $0.descriptionText
                self?.descriptionTextView.text = $0.descriptionText
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("textField.tag - \(textField.tag)")
        
        // 문자 입력수 제한
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        
        // 숫자만 입력
        let updatedText = (currentText as NSString)
            .replacingCharacters(in: range, with: string)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: updatedText)
        
        switch textField.tag {
            case 1001:
                return newLength <= 30
            case 1002, 1003:
                return newLength <= 3 && allowedCharacters.isSuperset(of: characterSet)
            default:
                return true
        }
    }

    // MARK: - Selector Methods
    
    @objc func doneButtonTapped() {
        print("doneButtonTapped!")
        switch entryViewModel.mode {
            case .add: entryViewModel.realmWriteExercise()
            case .update: print("TODO realm update")
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonTapped() {
        print("deleteButtonTapped!")
        switch entryViewModel.mode {
            case .add: return
            case .update(let detailViewModel):
                print(entryViewModel.entryExercise)
                detailViewModel.realmExerciseIsDeleted()
                navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Methods
    
    // 경고 라벨 hidden 애니메이션, 중복 애니메이션 방지 (고장남)
    private func warningLabelAnimation(_ targetView: UILabel?, isWarning: Bool) {
        guard let target = targetView else { return }
        guard target.isHidden == isWarning else { return } // 중복 방지
        UIView.animate(withDuration: 0.2) {
            target.isHidden = !isWarning
        }
    }
}

// MARK - Custom UI Class
private class PaddedTextField: UITextField {
    var padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setupUI() {
        clearButtonMode = .always
        borderStyle = .roundedRect
        layer.cornerRadius = 12
        layer.masksToBounds = true
        textColor = .white
        backgroundColor = .color2F2F2F
    }
}


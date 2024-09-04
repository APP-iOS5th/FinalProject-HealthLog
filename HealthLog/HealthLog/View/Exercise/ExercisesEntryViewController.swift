//
//  ExercisesFormViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/17/24.
//

import Combine
import UIKit
import PhotosUI

class ExercisesEntryViewController: UIViewController, UITextFieldDelegate, PHPickerViewControllerDelegate {
    
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
    private let imageViews = [UIImageView(), UIImageView()]
    private let imageCancelButtons = [UIButton(), UIButton()]
    
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
        
        setupMain()
        setupPaddingView(stackView: stackView, height: 5)
        setupTitleStackView()
        setupCreateDivider(stackView: stackView, height: 1)
        setupBodypartStackView()
        setupCreateDivider(stackView: stackView, height: 1)
        setupRecentWeightStackView()
        setupCreateDivider(stackView: stackView, height: 1)
        setupMaxWeightStackView()
        setupCreateDivider(stackView: stackView, height: 1)
        setupDescriptionStackView()
        setupCreateDivider(stackView: stackView, height: 1)
        setupImageStackView()
        setupDeleteButton()
        
        setupBindingsUpdateMode()
        setupBindingsUpdateUI()
        setupBindingsUpdateData()
    }
    
    // MARK: - Setup UI
    
    func setupMain() {
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
        
        // MARK: handleTapOutsideSearchArea
        // 검색바 및 운동부위 옵션 영역의 바깥을 터치시, 운동부위옵션 및 키보드 접기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSearchArea))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // MARK: scrollView
        view.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
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
        stackView.spacing = 15
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
    
    func setupPaddingView(stackView: UIStackView, height: CGFloat) {
        let paddingView = UIView()
        paddingView.backgroundColor = .clear
        stackView.addArrangedSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            paddingView.widthAnchor.constraint(
                equalTo: stackView.widthAnchor),
            paddingView.heightAnchor.constraint(
                equalToConstant: height)
        ])
    }
    
    func setupTitleStackView() {
        // MARK: titleStackView
        titleStackView.axis = .vertical
        titleStackView.distribution = .equalSpacing
        titleStackView.spacing = 10
        titleStackView.alignment = .leading
        titleStackView.isLayoutMarginsRelativeArrangement = true
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
        titleTextField.tag = ViewTag.titleTextField.rawValue
        titleTextField.delegate = self
        titleStackView.addArrangedSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(
                equalTo: stackView.leadingAnchor,
                constant: 10),
            titleTextField.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: -10),
        ])

        // MARK: titleDuplicateWarningLabel
        titleDuplicateWarningLabel.text = "이미 존재하는 운동 이름입니다."
        titleDuplicateWarningLabel.numberOfLines = 1
        titleDuplicateWarningLabel.textColor = .red
        titleDuplicateWarningLabel.isHidden = true
        titleStackView.addArrangedSubview(titleDuplicateWarningLabel)
        
        // MARK: titleEmptyWarningLabel
        titleEmptyWarningLabel.text = "운동 이름이 비어있습니다."
        titleEmptyWarningLabel.numberOfLines = 1
        titleEmptyWarningLabel.textColor = .red
        titleEmptyWarningLabel.isHidden = true
        titleStackView.addArrangedSubview(titleEmptyWarningLabel)
    }
    
    func setupBodypartStackView() {
        // MARK: bodypartStackView
        bodypartStackView.axis = .vertical
        bodypartStackView.distribution = .equalSpacing
        bodypartStackView.spacing = 10
        bodypartStackView.alignment = .leading
        bodypartStackView.backgroundColor = .color1E1E1E
        bodypartStackView.isLayoutMarginsRelativeArrangement = true
        bodypartStackView.layoutMargins = UIEdgeInsets(
            top: 10, left: 0, bottom: 10, right: 0)
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
        bodypartEmptyWarningLabel.isHidden = true
        bodypartStackView.addArrangedSubview(bodypartEmptyWarningLabel)
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
                equalTo: stackView.leadingAnchor,
                constant: 10),
            recentWeightLabel.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: -10),
        ])
        
        // MARK: recentWeightTextFieldStackView
        recentWeightTextFieldStackView.axis = .horizontal
        recentWeightTextFieldStackView.distribution = .fillEqually
        recentWeightTextFieldStackView.spacing = 10
        recentWeightStackView.addArrangedSubview(recentWeightTextFieldStackView)
        
        // MARK: recentWeightTextField
        recentWeightTextField.tag = ViewTag.recentWeightTextField.rawValue
        recentWeightTextField.delegate = self
        recentWeightTextField.textColor = .white
        recentWeightTextField.keyboardType = .numberPad
        recentWeightTextFieldStackView.addArrangedSubview(recentWeightTextField)
        
        // MARK: recentWeightKGLabel
        recentWeightKGLabel.text = "KG"
        recentWeightKGLabel.textColor = .white
        recentWeightTextFieldStackView.addArrangedSubview(recentWeightKGLabel)
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
                equalTo: stackView.leadingAnchor,
                constant: 10),
            maxWeightLabel.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: -10),
        ])
        
        // MARK: maxWeightTextFieldStackView
        maxWeightTextFieldStackView.axis = .horizontal
        maxWeightTextFieldStackView.distribution = .fillEqually
        maxWeightTextFieldStackView.spacing = 10
        maxWeightStackView.addArrangedSubview(maxWeightTextFieldStackView)
        
        // MARK: maxWeightTextField
        maxWeightTextField.tag = ViewTag.maxWeightTextField.rawValue
        maxWeightTextField.delegate = self
        maxWeightTextField.textColor = .white
        maxWeightTextField.keyboardType = .numberPad
        maxWeightTextFieldStackView.addArrangedSubview(maxWeightTextField)
        
        // MARK: maxWeightKGLabel
        maxWeightKGLabel.text = "KG"
        maxWeightKGLabel.textColor = .white
        maxWeightTextFieldStackView.addArrangedSubview(maxWeightKGLabel)
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
                equalTo: stackView.leadingAnchor,
                constant: 10),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: -10),
        ])
    }
    
    func setupImageStackView() {
        // MARK: ImageStackView
        imageStackView.axis = .vertical
        imageStackView.distribution = .fill
        imageStackView.spacing = 10
        imageStackView.alignment = .fill
        imageStackView.backgroundColor = .color1E1E1E
        stackView.addArrangedSubview(imageStackView)
        
        // MARK: imageLabel
        imageLabel.textColor = .white
        imageLabel.text = "운동 이미지"
        imageStackView.addArrangedSubview(imageLabel)
        
        // MARK: imageViews
        imageViews.enumerated().forEach { index, imageView in
            // imageContainerView
            let imageContainerView = UIView()
            imageStackView.addArrangedSubview(imageContainerView)
            imageContainerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageContainerView.leadingAnchor.constraint(
                    equalTo: stackView.leadingAnchor,
                    constant: 10),
                imageContainerView.trailingAnchor.constraint(
                    equalTo: stackView.trailingAnchor,
                    constant: -10),
                imageContainerView.heightAnchor.constraint(
                    equalTo: imageContainerView.widthAnchor,
                    multiplier: 9 / 16)
            ])
            
            // ImageView
            imageView.contentMode = .scaleAspectFit
            imageView.layer.borderWidth = 1
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self, 
                    action: #selector(tapImageViewShowPHPicker(_:)))
            )
            imageView.isUserInteractionEnabled = true
            imageView.tag = ViewTag.imageViews.setIndexTag(index)
            imageContainerView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(
                    equalTo: imageContainerView.leadingAnchor),
                imageView.trailingAnchor.constraint(
                    equalTo: imageContainerView.trailingAnchor),
                imageView.topAnchor.constraint(
                    equalTo: imageContainerView.topAnchor),
                imageView.bottomAnchor.constraint(
                    equalTo: imageContainerView.bottomAnchor),
            ])
            
            // imageView Cancel
            let cancelButton = imageCancelButtons[index]
            let symbolConfig = UIImage.SymbolConfiguration(
                pointSize: 20, weight: .heavy, scale: .large)
            let paletteConfig = UIImage.SymbolConfiguration(
                paletteColors: [.white, .colorAccent])
            let config = symbolConfig.applying(paletteConfig)
            let image = UIImage(systemName: "xmark.app.fill",
                                withConfiguration: config)
            cancelButton.setImage(image, for: .normal)
            cancelButton.tag = ViewTag.imageCancelButtons.setIndexTag(index)
            cancelButton.addTarget(
                self, action: #selector(tapImageCancelButton(_:)),
                for: .touchUpInside)
            imageView.addSubview(cancelButton)
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cancelButton.topAnchor.constraint(
                    equalTo: imageView.topAnchor,
                    constant: 10),
                cancelButton.trailingAnchor.constraint(
                    equalTo: imageView.trailingAnchor,
                    constant: -10),
            ])
            
            // ImageView Label
            let imageOpenLabel = UILabel()
            imageOpenLabel.text = "Open Gallery"
            imageOpenLabel.textColor = .white
            imageView.addSubview(imageOpenLabel)
            imageOpenLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageOpenLabel.centerXAnchor.constraint(
                    equalTo: imageView.centerXAnchor),
                imageOpenLabel.centerYAnchor.constraint(
                    equalTo: imageView.centerYAnchor,
                    constant: -30),
            ])
            
            // ImageView Icon
            let symbolImageView = UIImageView(
                image: UIImage(systemName: "photo.badge.plus"))
            symbolImageView.tintColor = .white
            symbolImageView.contentMode = .scaleAspectFit
            imageView.addSubview(symbolImageView)
            symbolImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                symbolImageView.centerXAnchor.constraint(
                    equalTo: imageView.centerXAnchor),
                symbolImageView.centerYAnchor.constraint(
                    equalTo: imageView.centerYAnchor,
                    constant: 10),
                symbolImageView.widthAnchor.constraint(
                    equalToConstant: 50),
                symbolImageView.heightAnchor.constraint(
                    equalToConstant: 50),
            ])
            
//            imageView.sendSubviewToBack(imageOpenLabel)
//            imageView.sendSubviewToBack(symbolImageView)
        } // end forEach
    }
    
    func setupDeleteButton() {
        guard case .update = entryViewModel.mode else { return }
        guard let deleteButton = deleteButton else { return }
        
        deleteButton.backgroundColor = .color2F2F2F
        deleteButton.setTitle("운동 삭제하기", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.layer.cornerRadius = 12
        deleteButton.layer.masksToBounds = true
        deleteButton.addTarget(
            self, action: #selector(deleteButtonTapped),
            for: .touchUpInside)
        stackView.addArrangedSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(
                equalTo: stackView.leadingAnchor,
                constant: 10),
            deleteButton.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: -10),
            deleteButton.heightAnchor.constraint(
                equalToConstant: 50),
        ])
    }
    
    private func setupCreateDivider(stackView: UIStackView, height: CGFloat) {
        let dividerView = UIView()
        dividerView.backgroundColor = .color2F2F2F
        stackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(
                equalTo: stackView.leadingAnchor,
                constant: 9),
            dividerView.trailingAnchor.constraint(
                equalTo: stackView.trailingAnchor,
                constant: -9),
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
        ])
    }
    
    // MARK: - Setup Binddings
    
    private func setupBindingsUpdateData() {
        // MARK: Input titleTextField
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: titleTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { text in
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

    }
    
    private func setupBindingsUpdateUI() {
        
        // MARK: Selected Image Show
        self.entryViewModel.entryExercise.$images
            .sink { [weak self] imagesData in
                imagesData.enumerated().forEach { index, data in
                    let uiImage = UIImage(data: data)
                    self?.imageViews[index].image = uiImage
                }
            }
            .store(in: &cancellables)
        
        // MARK: Image SubViews(label, icon) Show
        self.entryViewModel.entryExercise.$images
            .sink { [weak self] imagesData in
                imagesData.enumerated().forEach { index, data in
                    let subViewsShow = data.isEmpty ? true : false
                    self?.imageViews[index].subviews
                        .filter { !($0 is UIButton) }
                        .forEach { $0.isHidden = !subViewsShow }
                }
            }
            .store(in: &cancellables)
        
        
        // MARK: UI Duplicate ExerciseName Warning
        self.entryViewModel.entryExercise.$hasDuplicateName
            .sink { [weak self] hasDuplicate in
                let label = self?.titleDuplicateWarningLabel
                self?.warningLabelAnimation(label, isWarning: hasDuplicate)
            }
            .store(in: &cancellables)
        
        // MARK: Empty ExerciseName Warning
        self.entryViewModel.entryExercise.$isNameEmpty
            .sink { [weak self] isEmpty in
                let label = self?.titleEmptyWarningLabel
                self?.warningLabelAnimation(label, isWarning: isEmpty)
            }
            .store(in: &cancellables)
        
        // MARK: Empty Bodyparts Warning
        self.entryViewModel.entryExercise.$isBodyPartsEmpty
            .sink { [weak self] isEmpty in
                let label = self?.bodypartEmptyWarningLabel
                self?.warningLabelAnimation(label, isWarning: isEmpty)
            }
            .store(in: &cancellables)
        
        // MARK: Validated RequiredFields - Done Button
        self.entryViewModel.entryExercise.$isValidatedRequiredFields
            .sink { [weak self] isValidated in
                self?.navigationItem.rightBarButtonItem?
                    .isEnabled = isValidated
            }
            .store(in: &cancellables)
    }
    
    private func setupBindingsUpdateMode() {
        guard case .update(let detailViewModel) = entryViewModel.mode
        else { return }
        
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
                
                $0.images.enumerated().forEach { index, dbImage in
                    self?.entryViewModel.entryExercise
                        .images[index] = dbImage.image ?? Data()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 문자 입력수 제한
        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length
        
        // 숫자만 입력
        let updatedText = (currentText as NSString)
            .replacingCharacters(in: range, with: string)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: updatedText)
        
        switch textField.tag {
            case ViewTag.titleTextField.rawValue:
                return newLength <= 30
            case ViewTag.recentWeightTextField.rawValue, ViewTag.maxWeightTextField.rawValue:
                return newLength <= 3 &&
                allowedCharacters.isSuperset(of: characterSet)
            default:
                return true
        }
    }

    // MARK: - PHPickerViewControllerDelegate
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let result = results.first 
        else { return }
        
        // UIImage로 변환
        result.itemProvider.loadObject(ofClass: UIImage.self) { 
            [weak self] image, error in
            DispatchQueue.main.async {
                guard let uiImage = image as? UIImage,
                      let entryExercise = self?.entryViewModel.entryExercise
                else { return }
                
                let resizedImage = uiImage.resized(toMaxDimension: 360)
                guard let resizedImage = resizedImage,
                      let imageData = resizedImage
                    .jpegData(compressionQuality: 0.8)
                else { return }
                
                // 선택된 이미지에 따라 imageView 업데이트
                switch picker.view.tag {
                    case ViewTag.imageView1.rawValue:
                        entryExercise.images[0] = imageData
                    case ViewTag.imageView2.rawValue:
                        if(entryExercise.images[0].isEmpty &&
                           entryExercise.images[1].isEmpty) {
                            entryExercise.images[0] = imageData
                        } else {
                            entryExercise.images[1] = imageData
                        }
                    default: break
                }
            }
        }
    }
    
    
    // MARK: - Selector Methods
    
    @objc func doneButtonTapped() {
        print("doneButtonTapped!")
        switch entryViewModel.mode {
            case .add: entryViewModel.realmAddExercise()
            case .update(let detailViewModel):
                entryViewModel.realmUpdateExercise()
                let prevVC = navigationController?.viewControllers.first( where: {
                    $0 is ExercisesDetailViewController
                }) as? ExercisesDetailViewController
                prevVC?.navigationItem.title = detailViewModel.exercise.name
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonTapped() {
        print("deleteButtonTapped!")
        deleteAlertAction()
    }
    
    // 이미지 선택 버튼 눌렀을 때 호출되는 함수
    @objc private func selectTapImageButton() {
        print("selectTapImageButton")
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 2
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func tapImageViewShowPHPicker(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.view.tag = tappedImageView.tag
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func tapImageCancelButton(_ sender: UIButton) {
        let entryExercise = self.entryViewModel.entryExercise
        if(sender.tag - 10 == ViewTag.imageView1.rawValue) {
            // 첫번째 삭제 실행시, 두번째를 첫번째로 이동
            entryExercise.images[0] = entryExercise.images[1]
        }
        entryExercise.images[1] = Data()
    }
    
    @objc private func handleTapOutsideSearchArea(_ sender: UITapGestureRecognizer) {
        let isTappedInsideTitleTextField = titleTextField.frame.contains(sender.location(in: view))
        let isTappedInsideMaxWeightTextField = maxWeightTextField.frame.contains(sender.location(in: view))
        let isTappedInsideRecentWeightTextField = recentWeightTextField.frame.contains(sender.location(in: view))
        let isTappedInsideDescriptionTextView = descriptionTextView.frame.contains(sender.location(in: view))
        
        // 검색옵션스택뷰와 검색바 이외의 영역을 터치한 경우
        if !(isTappedInsideTitleTextField ||
             isTappedInsideMaxWeightTextField ||
             isTappedInsideRecentWeightTextField ||
             isTappedInsideDescriptionTextView)  {
            print("Tap detected outside input area")
            view.endEditing(true)
        }
    }
    
    
    // MARK: - Methods
    
    // 경고 라벨 hidden 애니메이션, 중복 애니메이션 방지 (중복 실행시 고장남)
    private func warningLabelAnimation(_ targetView: UILabel?, isWarning: Bool) {
        guard entryViewModel.warningCount >= 3 else {
            return entryViewModel.warningCount += 1
        } // 첫 실행시에는 경고 표시 안함
        guard let target = targetView else { return }
        guard target.isHidden == isWarning else { return } // 중복 방지
        UIView.animate(withDuration: 0.2) {
            target.isHidden = !isWarning
        }
    }
    
    private func deleteAlertAction() {
        guard case .update = entryViewModel.mode
        else { return }
        
        let alertController = UIAlertController(
            title: "삭제 확인",
            message: "삭제시, 더이상 운동리스트에서는 표시되지 않습니다.",
            preferredStyle: .alert
        )
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .color767676
        alertController.view.layer.cornerRadius = 15
        
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            // 삭제 처리 코드
            self.entryViewModel.realmExerciseIsDeleted()
            self.navigationController?.popToRootViewController(animated: true)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
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


private enum ViewTag: Int {
    case titleTextField = 1001
    case recentWeightTextField = 1002
    case maxWeightTextField = 1003
    case imageViews = 2000
    case imageView1 = 2001
    case imageView2 = 2002
    case imageCancelButtons = 2010
    case imageCancelButton1 = 2011
    case imageCancelButton2 = 2012
    
    func setIndexTag(_ index: Int) -> Int {
        return self.rawValue + index + 1
    }
}




private extension UIImage {
    /// 이미지를 주어진 최대 크기로 리사이즈하며 원본 비율을 유지합니다.
    func resized(toMaxDimension maxDimension: CGFloat) -> UIImage? {
        // 원본 그대로 리턴
        guard size.width > maxDimension ||
                size.height > maxDimension else { return self }
        
        let aspectRatio = size.width / size.height
        
        // SD 해상도를 기준으로 한 가로/세로 값 계산
        var newSize: CGSize
        if size.width > size.height {
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
        
        // 새로운 크기로 리사이즈
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

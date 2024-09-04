//
//  ExerciseDetailViewController.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/22/24.
//

import Combine
import UIKit

class ExercisesDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let detailViewModel: ExerciseDetailViewModel
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    // diverdier
    private let dividerView = UIView()
    
    // top group (profile)
    private let profileLabel = UILabel()
    private let profileStackView = UIStackView()
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let bodypartStackView = DetailBodyPartStackView()
    private let descriptionLabel = UILabel()
    
    // bottom group (log)
    private let logLabel = UILabel()
    private let logStackView = UIStackView()
    private let totalRepsLogContentStackView = LogContentStackView()
    private let recentWeightLogContentStackView = LogContentStackView()
    private let maxWeightLogContentStackView = LogContentStackView()
    
    
    // MARK: - Init
    
    init(detailViewModel: ExerciseDetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .color1E1E1E
        setupPaddingView(stackView: stackView, height: 10)
        setupMain()
        setupProfileGroup()
        setupPaddingView(stackView: stackView, height: 10)
        setupLogGroup()
        setupBindings()
    }
    
    // MARK: - Setup
    
    func setupMain() {
        title = detailViewModel.exercise.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let editPushButton = UIBarButtonItem(
            title: "수정", style: .plain, target: self,
            action: #selector(editPushButtonTapped))
        editPushButton.isEnabled = detailViewModel.exercise.isCustom
        self.navigationItem.rightBarButtonItem = editPushButton
        
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
                constant: 17),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -17),
        ])
        
        // MARK: stackView
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.alignment = .fill
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
    
    func setupDivider() {
        // MARK: dividerView
        dividerView.backgroundColor = .color767676
        stackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    func setupProfileGroup() {
        // MARK: profileLabel
        profileLabel.text = "정보"
        profileLabel.textColor = .color767676
        profileLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        stackView.addArrangedSubview(profileLabel)
        
        // MARK: profileStackView
        profileStackView.axis = .vertical
        profileStackView.alignment = .center
        profileStackView.spacing = 15
        profileStackView.layer.cornerRadius = 10
        profileStackView.clipsToBounds = true
        profileStackView.isLayoutMarginsRelativeArrangement = true
        profileStackView.layoutMargins = UIEdgeInsets(
            top: 15, left: 15, bottom: 15, right: 15)
        profileStackView.backgroundColor = .color3E3E3E
        stackView.addArrangedSubview(profileStackView)
        
        // MARK: imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        profileStackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(
                equalTo: stackView.widthAnchor,
                constant: -50),
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: 9 / 16)
        ])
        
        // MARK: bodypartStackView
        profileStackView.addArrangedSubview(bodypartStackView)
        
        // MARK: descriptionLabel
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
        profileStackView.addArrangedSubview(descriptionLabel)
    }
    
    func setupLogGroup() {
        // MARK: logLabel
        logLabel.text = "기록"
        logLabel.textColor = .color767676
        logLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        stackView.addArrangedSubview(logLabel)
        
        // MARK: logStackView
        logStackView.axis = .horizontal
        logStackView.alignment = .center
        logStackView.distribution = .fillEqually
        logStackView.spacing = 15
        logStackView.layer.cornerRadius = 10
        logStackView.clipsToBounds = true
        logStackView.isLayoutMarginsRelativeArrangement = true
        logStackView.layoutMargins = UIEdgeInsets(
            top: 15, left: 15, bottom: 15, right: 15)
        logStackView.backgroundColor = .color3E3E3E
        stackView.addArrangedSubview(logStackView)
        
        // MARK: totalRepsLogContentStackView
        totalRepsLogContentStackView
            .configure(symbolName: "square.stack.3d.up", title: "총 운동 회수")
        logStackView.addArrangedSubview(totalRepsLogContentStackView)
        
        // MARK: recentWeightLogContentStackView
        recentWeightLogContentStackView
            .configure(symbolName: "scalemass", title: "최근 무게")
        logStackView.addArrangedSubview(recentWeightLogContentStackView)
        
        // MARK: maxWeightLogContentStackView
        maxWeightLogContentStackView
            .configure(symbolName: "trophy", title: "최대 무게")
        logStackView.addArrangedSubview(maxWeightLogContentStackView)
    }
    
    func setupBindings() {
        detailViewModel.$exercise
            .sink { [weak self] exercise in
                self?.bodypartStackView.arrangedSubviews
                    .forEach { $0.removeFromSuperview() }
                
                self?.title = exercise.name
                self?.bodypartStackView.configure(
                    bodyparts: Array(exercise.bodyParts),
                    maxRowWidth: (self?.view.bounds.width ?? 0) - 70)
                self?.descriptionLabel.text = exercise.descriptionText
                self?.totalRepsLogContentStackView.reloadValueLabel(unit: "Reps", value: "\(exercise.totalReps)")
                self?.recentWeightLogContentStackView.reloadValueLabel(unit: "KG", value: "\(exercise.recentWeight)")
                self?.maxWeightLogContentStackView.reloadValueLabel(unit: "KG", value: "\(exercise.maxWeight)")
                self?.imageView.image = UIImage(
                    data: exercise.images.first?.image ?? Data())
//                self?.updateImageViewWithImage()
                
            }
            .store(in: &cancellables)
        
        detailViewModel.$currentImageIndex
            .sink { [weak self] index in
                guard let self = self else { return }
                let images = Array(self.detailViewModel.exercise.images)
                if images.count > 0 {
                    self.imageView.image = UIImage(
                        data: images[index].image ?? Data())
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Selector Methods
    
    @objc func editPushButtonTapped() {
        print("editPushButtonTapped!")
        let entryViewModel = ExerciseEntryViewModel(
            mode: .update(detailViewModel), viewModel: detailViewModel.viewModel)
        let vc = ExercisesEntryViewController(entryViewModel: entryViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Methods
    
}


// MARK: - LogContentStackView
private class LogContentStackView: UIStackView {
    
    // MARK: Properties
    
    private let symbolImageContentView = UIImageView()
    private let symbolImageBorderView = UIImageView()
    private let titleLabel = UILabel()
    private let dividerView = UIView()
    private let valueLabel = UILabel()
    
    // MARK: Initializers
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setupUI() {
        axis = .vertical
        alignment = .center
        spacing = 9
        distribution = .equalSpacing
        layer.cornerRadius = 10
        clipsToBounds = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        backgroundColor = .color1E1E1E
        
        // MARK: symbolImageView
        symbolImageContentView.contentMode = .scaleAspectFit
        symbolImageContentView.tintColor = .colorAccent
        addArrangedSubview(symbolImageContentView)
        
        symbolImageBorderView.contentMode = .scaleAspectFit
        symbolImageBorderView.tintColor = .white
        symbolImageContentView.addSubview(symbolImageBorderView)
        symbolImageBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            symbolImageBorderView.centerXAnchor.constraint(
                equalTo: symbolImageContentView.centerXAnchor),
            symbolImageBorderView.centerYAnchor.constraint(
                equalTo: symbolImageContentView.centerYAnchor),
        ])
        
        
        // MARK: titleLabel
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 15)
        titleLabel.textColor = .color767676
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        addArrangedSubview(titleLabel)
        
        // MARK: dividerView
        dividerView.backgroundColor = .color525252
        addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(
                equalToConstant: 1),
            dividerView.widthAnchor.constraint(
                equalTo: widthAnchor, constant: -20),
        ])

        // MARK: valueLabel
        valueLabel.textColor = .color767676
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.7
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(valueLabel)
    }
    
    func configure(symbolName: String, title: String) {
        titleLabel.text = title
        imageConfigure(symbolName: symbolName)
    }
    
    func reloadValueLabel(unit: String, value: String) {
        valueLabel.attributedText = attributedString(value: value, unit: unit)
    }
    
    // MARK: Sub Methods
    
    private func attributedString(value: String, unit: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.85
        
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 25) ??
            UIFont.systemFont(ofSize: 25, weight: .bold),
            .paragraphStyle: paragraphStyle]
        let valueString = NSAttributedString(
            string: value, attributes: valueAttributes)
        
        let kgAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Pretendard-Bold", size: 12) ??
            UIFont.systemFont(ofSize: 12, weight: .bold)]
        let kgString = NSAttributedString(
            string: unit, attributes: kgAttributes)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(valueString)
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(kgString)
        return attributedString
    }
    
    private func imageConfigure(symbolName: String) {
        symbolImageContentView.image = UIImage(
            systemName: symbolName + ".fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        symbolImageBorderView.image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        
        guard symbolName == "scalemass" else { return }
        let symbolImageContentKGLabel = UILabel()
        symbolImageContentKGLabel.text = "KG"
        symbolImageContentKGLabel.textColor = .white
        symbolImageContentKGLabel.font = UIFont(name: "Pretendard-Bold", size: 10)
        symbolImageBorderView.addSubview(symbolImageContentKGLabel)
        symbolImageContentKGLabel
            .translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            symbolImageContentKGLabel.centerXAnchor.constraint(
                equalTo: symbolImageBorderView.centerXAnchor),
            symbolImageContentKGLabel.centerYAnchor.constraint(
                equalTo: symbolImageBorderView.centerYAnchor,
                constant: 5),
        ])
    }
}


// MARK: - DetailBodyPartStackView
private class DetailBodyPartStackView: UIStackView {
    
    // MARK: Properties
    
    private var bodyparts: [BodyPart]?
    
    // 스택뷰 안쪽 생성 작업때 쓸 현재상태 변수
    private var currentRow: UIStackView!
    private var currentLabel: CustomBodyPartLabel!
    private var maxRowWidth: CGFloat!
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    public func stackContentHidden (isHidden: Bool) {
        arrangedSubviews.forEach { $0.isHidden = isHidden }
        isLayoutMarginsRelativeArrangement = !isHidden
    }

    public func configure(bodyparts: [BodyPart], maxRowWidth: CGFloat) {
        self.bodyparts = bodyparts
        self.maxRowWidth = maxRowWidth
        addContentsToStackView()
        deleteCurrentProperties()
    }
    
    // MARK: Private Methods
    
    private func setupStackView() {
        axis = .vertical
        spacing = 10
        distribution = .equalSpacing
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 13, right: 0)
    }
    
    private func addContentsToStackView() {
        currentRow = RowStackView()
        self.addArrangedSubview(currentRow)
        guard let bodyparts else { return }
        for bodypart in bodyparts {
            currentLabel = CustomBodyPartLabel()
            currentLabel.text = bodypart.rawValue
            currentLabel.font = UIFont(name: "Pretendard-Medium", size: 16)
            
            let width = calculatorLabelAddAfterWidth()
            checkCreateAfterRow(labelAddAfterWidth: width)
            currentRow.addArrangedSubview(currentLabel)
        }
    }
    
    private func deleteCurrentProperties() {
        currentRow = nil
        currentLabel = nil
    }
    
    // MARK: Sub Private Methods
    
    // 현재 버튼들이 포함된 Row(버튼 가로줄)의 가로폭 계산
    private func calculatorLabelAddAfterWidth() -> CGFloat {
        let allRowLabelWidth = currentRow
            .arrangedSubviews.reduce(0, { sum, label in
                sum + label.intrinsicContentSize.width +
                currentRow.spacing
            })
        return allRowLabelWidth + currentLabel.intrinsicContentSize.width
    }
    
    // 가로폭이 넘쳤나 확인 후, 새로운 Row(버튼 가로줄) 생성
    private func checkCreateAfterRow(labelAddAfterWidth: CGFloat) {
        if labelAddAfterWidth > maxRowWidth {
            currentRow = RowStackView()
            addArrangedSubview(currentRow)
        }
    }
    
    
    // MARK: Sub UI
    private class RowStackView: UIStackView {
        init() {
            super.init(frame: .zero)
            setup()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            axis = .horizontal
            spacing = 5
            distribution = .fillProportionally
            alignment = .center
        }
    }

}


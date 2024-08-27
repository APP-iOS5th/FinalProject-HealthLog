//
//  ExercisesListCell.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import UIKit

class ExerciseListCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    let stackView = UIStackView()
    
    // 상단 영역
    let topStackView = UIStackView()
    let titleLabel = UILabel()
    let detailButton = UIButton(type: .system)
    
    // 구분선
    let dividerView = UIView()
    
    // 하단 영역
    let bottomStackView = UIStackView()
    var exerciseImageView = UIImageView()
    let bottomRightStackView = UIStackView()
    let bodypartScrollView = UIScrollView()
    let bodypartStackView = UIStackView()
    var bodypartLabels: [CustomBodyPartLabel] = []
    let descriptionTextView = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupTopStackView()
        setupDivider()
        setupBottomStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 13, left: 17, bottom: 0, right: 17))
    }
    
    // MARK: - Setup UI
    
    private func setupCell() {
        backgroundColor = .color1E1E1E
        contentView.backgroundColor = .colorSecondary
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 16, left: 16, bottom: 16, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupTopStackView() {
        // MARK: topStackView
        topStackView.axis = .horizontal
        topStackView.distribution = .equalSpacing
        topStackView.spacing = 4
        stackView.addArrangedSubview(topStackView)

        // MARK: titleLabel
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        topStackView.addArrangedSubview(titleLabel)
        
        // MARK: detailButton
        detailButton.setTitle("자세히 보기 ❯", for: .normal)
        detailButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 12)
        detailButton.setTitleColor(.lightGray, for: .normal)
        detailButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        topStackView.addArrangedSubview(detailButton)
    }
    
    func setupDivider() {
        // MARK: dividerView
        dividerView.backgroundColor = .color1E1E1E
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(
                equalToConstant: 1)
        ])
    }
    
    private func setupBottomStackView() {
        // MARK: bottomStackView
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fill
        bottomStackView.spacing = 10
        stackView.addArrangedSubview(bottomStackView)
        
        // MARK: exerciseImageView
        exerciseImageView.contentMode = .scaleToFill
        exerciseImageView.clipsToBounds = true
        exerciseImageView.backgroundColor = .color3E3E3E
        exerciseImageView.layer.borderColor = UIColor.black.cgColor
        exerciseImageView.layer.borderWidth = 1.0
        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.addArrangedSubview(exerciseImageView)
        NSLayoutConstraint.activate([
            exerciseImageView.widthAnchor.constraint(
                equalToConstant: 90),
            exerciseImageView.heightAnchor.constraint(
                equalToConstant: 120),
        ])
        
        // MARK: bottomRightStackView
        bottomRightStackView.axis = .vertical
        bottomRightStackView.distribution = .fill
        bottomRightStackView.spacing = 1
        bottomStackView.addArrangedSubview(bottomRightStackView)
        
        // MARK: bodypartScrollView
        bodypartScrollView.showsHorizontalScrollIndicator = false
        bodypartScrollView.showsVerticalScrollIndicator = false
        bottomRightStackView.addArrangedSubview(bodypartScrollView)
        
        // MARK: bodypartStackView
        bodypartStackView.axis = .horizontal
        bodypartStackView.distribution = .equalSpacing
        bodypartStackView.spacing = 8
        bodypartStackView.translatesAutoresizingMaskIntoConstraints = false
        bodypartScrollView.addSubview(bodypartStackView)
        NSLayoutConstraint.activate([
            bodypartStackView.topAnchor.constraint(
                equalTo: bodypartScrollView.topAnchor),
            bodypartStackView.bottomAnchor.constraint(
                equalTo: bodypartScrollView.bottomAnchor),
            bodypartStackView.leadingAnchor.constraint(
                equalTo: bodypartScrollView.leadingAnchor),
            bodypartStackView.trailingAnchor.constraint(
                equalTo: bodypartScrollView.trailingAnchor),
            bodypartStackView.heightAnchor.constraint(
                equalTo: bodypartScrollView.heightAnchor)
        ])
        
        // MARK: descriptionLabel
        descriptionTextView.font = UIFont(name: "Pretendard-Medium", size: 14)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .color767676
        descriptionTextView.numberOfLines = 0
        bottomRightStackView.addArrangedSubview(descriptionTextView)
    }
    
    // MARK: - Configure
    
    func configure(with exercise: Exercise) {
        // exercise.name
        titleLabel.text = exercise.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.calculateHeight(for: titleLabel.frame.width)).isActive = true

        // exercise.Image
        exerciseImageView.image = UIImage(data: exercise.image ?? Data())
        
        // exercise.bodyParts
        bodypartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for part in exercise.bodyParts {
            let label = CustomBodyPartLabel()
            label.text = part.rawValue
            bodypartStackView.addArrangedSubview(label)
        }
        
        // exercise.descriptionText
        descriptionTextView.text = exercise.descriptionText
    }
    
    // 자세히 보기 버튼 - 상세 화면 이동
    func configurePushDetailViewButton(
        with exercise: Exercise,
        viewModel: ExerciseViewModel,
        navigationController: UINavigationController) {
        detailButton.removeTarget(nil, action: nil, for: .touchUpInside)
        detailButton.addAction(UIAction { _ in
            let detailViewModel = ExerciseDetailViewModel(
                exercise: exercise, viewModel: viewModel)
            let vc = ExercisesDetailViewController(
                detailViewModel: detailViewModel)
            navigationController.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
    }
    
}

// MARK: - Extension UILabel
extension UILabel {
    /// 주어진 너비와 폰트를 기준으로 UILabel의 높이를 계산하는 메서드
    func calculateHeight(for width: CGFloat) -> CGFloat {
        guard let text = self.text else { return 0 }
        let boundingBox = text.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [],
            attributes: [.font: self.font!],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}

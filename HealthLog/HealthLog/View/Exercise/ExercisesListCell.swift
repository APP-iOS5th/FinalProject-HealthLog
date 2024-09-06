//
//  ExercisesListCell.swift
//  HealthLog
//
//  Created by youngwoo_ahn on 8/12/24.
//

import UIKit

class ExerciseListCell: UITableViewCell {
    
    // MARK: - Properties
    
    let containerView = UIView()
    let stackView = UIStackView()
    
    // 상단 영역
    let topStackView = UIStackView()
    let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    // 구분선
    let dividerView = UIView()
    
    // 하단 영역
    let bottomContainerView = UIView()
    var exerciseImageView = UIImageView()
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
        setupBottomContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup UI
    
    private func setupCell() {
        backgroundColor = .color1E1E1E
        contentView.backgroundColor = .color1E1E1E

        
        // MARK: containerView
        containerView.backgroundColor = .colorSecondary
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -20),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 17),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -17),
        ])
        
        // MARK: stackView
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 13
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 16, left: 16, bottom: 16, right: 16)
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor),
        ])
    }
    
    private func setupTopStackView() {
        // MARK: topStackView
        topStackView.axis = .horizontal
        topStackView.distribution = .equalCentering
        topStackView.alignment = .center
        topStackView.spacing = 4
        stackView.addArrangedSubview(topStackView)

        // MARK: titleLabel
        titleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        topStackView.addArrangedSubview(titleLabel)
        
        // MARK: detailLabel
        detailLabel.text = "자세히 보기 ❯"
        detailLabel.textColor = .lightGray
        detailLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        detailLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        topStackView.addArrangedSubview(detailLabel)
    }
    
    func setupDivider() {
        // MARK: dividerView
        dividerView.backgroundColor = .color252525
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(
                equalToConstant: 3)
        ])
    }
    
    private func setupBottomContainerView() {
        // MARK: bottomContainerView
        stackView.addArrangedSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomContainerView.heightAnchor.constraint(
                equalToConstant: 90),
        ])
        
        // MARK: exerciseImageView
        
        exerciseImageView.clipsToBounds = true
        exerciseImageView.backgroundColor = .white
        exerciseImageView.layer.cornerRadius = 12
        exerciseImageView.layer.masksToBounds = true
        exerciseImageView.tintColor = .color525252
        exerciseImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(exerciseImageView)
        NSLayoutConstraint.activate([
            exerciseImageView.leadingAnchor.constraint(
                equalTo: bottomContainerView.leadingAnchor),
            exerciseImageView.topAnchor.constraint(
                equalTo: bottomContainerView.topAnchor),
            exerciseImageView.widthAnchor.constraint(
                equalToConstant: 90),
            exerciseImageView.heightAnchor.constraint(
                equalToConstant: 90),
        ])
        
        // MARK: bodypartScrollView
        bodypartScrollView.showsHorizontalScrollIndicator = false
        bodypartScrollView.showsVerticalScrollIndicator = false
        bottomContainerView.addSubview(bodypartScrollView)
        bodypartScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodypartScrollView.leadingAnchor.constraint(
                equalTo: exerciseImageView.trailingAnchor,
                constant: 10),
            bodypartScrollView.topAnchor.constraint(
                equalTo: bottomContainerView.topAnchor),
            bodypartScrollView.trailingAnchor.constraint(
                equalTo: bottomContainerView.trailingAnchor),
            bodypartScrollView.heightAnchor.constraint(
                equalToConstant: 40)
        ])
        
        // MARK: bodypartStackView
        bodypartStackView.axis = .horizontal
        bodypartStackView.distribution = .equalSpacing
        bodypartStackView.alignment = .top
        bodypartStackView.spacing = 10
        bodypartScrollView.addSubview(bodypartStackView)
        bodypartStackView.translatesAutoresizingMaskIntoConstraints = false
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
        descriptionTextView.font = UIFont(name: "Pretendard-Light", size: 14)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = .white
        descriptionTextView.numberOfLines = 0
        bottomContainerView.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(
                equalTo: exerciseImageView.trailingAnchor,
                constant: 15),
            descriptionTextView.topAnchor.constraint(
                equalTo: bodypartScrollView.bottomAnchor),
            descriptionTextView.trailingAnchor.constraint(
                equalTo: bottomContainerView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(
                equalTo: bottomContainerView.bottomAnchor),
        ])
    }
    
    // MARK: - Configure
    
    func configure(with exercise: Exercise) {
        // exercise.name
        titleLabel.text = exercise.name

        // exercise.Image
        if let imageData = exercise.images.first?.image {
            exerciseImageView.image = UIImage(data: imageData)
            exerciseImageView.contentMode = .scaleAspectFit
            exerciseImageView.backgroundColor = .white
        } else {
            exerciseImageView.image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 5, weight: .regular))
            exerciseImageView.contentMode = .scaleAspectFit
            exerciseImageView.backgroundColor = .color3E3E3E
        }
        
        // exercise.bodyParts
        bodypartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for part in exercise.bodyParts {
            let label = CustomBodyPartLabel()
            label.text = part.rawValue
            label.setContentCompressionResistancePriority(.required, for: .vertical)
            bodypartStackView.addArrangedSubview(label)
        }
        
        // exercise.descriptionText
        descriptionTextView.text = exercise.descriptionText
    }
    
}

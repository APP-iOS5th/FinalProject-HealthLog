//
//  GetRoutineCell.swift
//  HealthLog
//
//  Created by seokyung on 8/28/24.
//

import UIKit

class GetRoutineCell: UITableViewCell {
    static let cellId = "GetRoutineCell"
    var addButtonTapped: (() -> Void)?
    var routine: Routine?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴 이름"
        label.font = UIFont.font(.pretendardBold, ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var addExerciseButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        configuration.title = "오늘 할 운동 추가"
        configuration.attributedTitle?.font = UIFont.font(.pretendardBold, ofSize: 14)
        button.configuration = configuration
        button.backgroundColor = .colorAccent
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var exercisesLabel: UILabel = {
        let label = UILabel()
        label.text = "운동들"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var exercisesVolumLabel: UILabel = {
        let label = UILabel()
        label.text = "운동 볼륨 : 0 kg"
        label.font = UIFont.font(.pretendardMedium, ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.color1E1E1E
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 운동 부위 스크롤뷰
    private lazy var bodypartScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // 운동 부위 스텍뷰
    private lazy var bodypartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .color1E1E1E
        self.contentView.backgroundColor = .color2F2F2F
        self.contentView.layer.cornerRadius = 12
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(exercisesLabel)
        self.contentView.addSubview(dividerView)
        self.contentView.addSubview(exercisesVolumLabel)
        self.contentView.addSubview(bodypartScrollView)
        self.contentView.addSubview(addExerciseButton)
        self.bodypartScrollView.addSubview(bodypartStackView)
        
        let padding: CGFloat = 22
        let safeArea = self.contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 13),
            self.titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            self.titleLabel.trailingAnchor.constraint(equalTo: addExerciseButton.leadingAnchor),
            
            
            self.addExerciseButton.topAnchor.constraint(equalTo: self.titleLabel.topAnchor),
            self.addExerciseButton.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.addExerciseButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            
            self.dividerView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 14),
            self.dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            self.exercisesLabel.topAnchor.constraint(equalTo: self.dividerView.topAnchor, constant: 13),
            self.exercisesLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            self.exercisesLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            
            self.exercisesVolumLabel.topAnchor.constraint(equalTo: self.exercisesLabel.bottomAnchor, constant: 3),
            self.exercisesVolumLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding),
            self.exercisesVolumLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding),
            
            self.bodypartScrollView.topAnchor.constraint(equalTo: self.exercisesVolumLabel.bottomAnchor,constant: 4),
            self.bodypartScrollView.leadingAnchor.constraint(equalTo: self.exercisesVolumLabel.leadingAnchor),
            self.bodypartScrollView.trailingAnchor.constraint(equalTo: self.exercisesVolumLabel.trailingAnchor),
            self.bodypartScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -13),
            
            self.bodypartStackView.topAnchor.constraint(equalTo: self.bodypartScrollView.topAnchor),
            self.bodypartStackView.leadingAnchor.constraint(equalTo: self.bodypartScrollView.leadingAnchor),
            self.bodypartStackView.trailingAnchor.constraint(equalTo: self.bodypartScrollView.trailingAnchor),
            self.bodypartStackView.bottomAnchor.constraint(equalTo: self.bodypartScrollView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24))
    }
    
    @objc func buttonTapped() {
        addButtonTapped?()
    }
    
    func configure(with routine: Routine) {
        titleLabel.text = routine.name
        var exercisesName: [String] = []
        routine.exercises.forEach { exercise in
            exercisesName.append(exercise.exercise?.name ?? "")
        }
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let volum = numberFormatter.string(for: routine.exerciseVolume)!
        exercisesLabel.text = exercisesName.joined(separator: ", ")
        exercisesVolumLabel.text = "운동 볼륨: \(String(describing: volum)) kg"
        
        bodypartStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        var bodyParts:[String] = []
        
        routine.exercises.forEach { exercise in
            exercise.exercise?.bodyParts.forEach{ bodyPart in
                bodyParts.append(bodyPart.rawValue)
            }
        }
        
        for part in Array(Set(bodyParts)) {
            let label = CustomBodyPartLabel()
            label.text = part
            bodypartStackView.addArrangedSubview(label)
        }
    }
    
}

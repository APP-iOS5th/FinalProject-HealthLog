//
//  ExercisesAddViewController.swift
//  HealthLog
//
//  Created by user on 8/17/24.
//

import Combine
import UIKit

class ExercisesAddViewController: UIViewController {
    
    // MARK: - Declare
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel = ExerciseViewModel()
    
    let stackView = UIStackView()
    
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let titleWarningLabel = UILabel()
    
    let bodypartStackView = UIStackView()
    let recentWeightStackView = UIStackView()
    let maxWeightStackView = UIStackView()
    let descriptionStackView = UIStackView()
    let imageStackView = UIStackView()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupTitleStackView()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        title = "운동 추가"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // MARK: addButton
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        self.navigationItem.rightBarButtonItem = doneButton
        
        // MARK: stackView
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
        ])
    }
    
    func setupTitleStackView() {
        // MARK: titleStackView
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 10
        stackView.addArrangedSubview(titleStackView)
        
        // MARK: titleLabel
        titleLabel.textColor = .white
        let titleLabelText = "운동 이름 *"
        let attributedString = NSMutableAttributedString(string: titleLabelText)
        let range = (titleLabelText as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        titleLabel.attributedText = attributedString
        titleStackView.addArrangedSubview(titleLabel)
        
        // MARK: titleTextField
        
    }
    
    
    
    // MARK: Methods
    
    @objc func doneButtonTapped() {
        print("doneButtonTapped!")
    }
    
}

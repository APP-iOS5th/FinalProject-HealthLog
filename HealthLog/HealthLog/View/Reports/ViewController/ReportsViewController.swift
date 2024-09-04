//
//  ReportsViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit
import Combine

class ReportsViewController: UIViewController {
    
    private var reportsVM = ReportsViewModel()
    
    private var inBodyVM = InBodyChartViewModel()
    
    private lazy var exerciseRecordVC: ExerciseRecordViewController = {
        let vc = ExerciseRecordViewController(reportsVM: self.reportsVM)
        return vc
    }()
    
    private lazy var weightRecordVC: WeightRecordViewController = {
        let vc = WeightRecordViewController(inBodyVM: inBodyVM)
        return vc
    }()
    
    
    private var currentVC: UIViewController?
    
    private var currentYear: Int {
        return reportsVM.currentYear
    }
    
    private var currentMonth: Int {
        return reportsVM.currentMonth
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private lazy var moveToPreviousMonthButton: UIButton = {
        let button = createMonthButton(action: UIAction {[weak self] _ in
            self?.didTapPreviousMonth()
        }, imageName: "chevron.left")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "2024년 7월 리포트"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var moveToNextMonthButton: UIButton = {
        let button = createMonthButton(action: UIAction {[weak self] _ in
            self?.didTapNextMonth()
        }, imageName: "chevron.right")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "운동 기록", at: 0, animated: true)
        control.insertSegment(withTitle: "인바디 기록", at: 1, animated: true)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        
        
        control.selectedSegmentTintColor = UIColor(named: "ColorAccent")
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        control.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13)
        ], for: .normal)
        
        control.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13)
        ], for: .selected)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateTitleMonthLabel()
        
        reportsVM.$bodyPartDataList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.exerciseRecordVC.fetchDataAndUpdateUI()
            }
            .store(in: &cancellables)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reportsVM.fetchAndCalculateCurrentMonthData()
    }
    
    

    
    private func updateTitleMonthLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 M월 리포트"
        
        if let date = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth)) {
            titleMonthLabel.text = dateFormatter.string(from: date)
        }
    }
    
    
    private func didTapPreviousMonth() {
        let newYear: Int
        let newMonth: Int
        
        if currentMonth == 1 {
            newYear = currentYear - 1
            newMonth = 12
        } else {
            newYear = currentYear
            newMonth = currentMonth - 1
        }
        
        reportsVM.updateYearAndMonth(year: newYear, month: newMonth)
        inBodyVM.updateYearAndMonth(year: newYear, month: newMonth)
        
        
        updateTitleMonthLabel()
        exerciseRecordVC.fetchDataAndUpdateUI()
    }
    
    private func didTapNextMonth() {
        let newYear: Int
        let newMonth: Int
        
        if currentMonth == 12 {
            newYear = currentYear + 1
            newMonth = 1
        } else {
            newYear = currentYear
            newMonth = currentMonth + 1
        }
        
        reportsVM.updateYearAndMonth(year: newYear, month: newMonth)
        inBodyVM.updateYearAndMonth(year: newYear, month: newMonth)
        
        
        updateTitleMonthLabel()
        exerciseRecordVC.fetchDataAndUpdateUI()
    }
    
    
    
    // MARK: SegmentControl
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()
        
        let newVC: UIViewController
        if selectedIndex == 0 {
            newVC = exerciseRecordVC
        } else {
            newVC = weightRecordVC
        }
        
        addChild(newVC)
        newVC.didMove(toParent: self)
        currentVC = newVC
        
//        updateDataForCurrentMonth()
        
    }
    
    private func createMonthButton(action: UIAction, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: imageName, withConfiguration: symbolConfig)
        config.baseForegroundColor = .white
        button.configuration = config
        
        button.addAction(action, for: .touchUpInside)
        return button
    }
    
    
    

}

extension ReportsViewController {
    
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        
        titleStackView.addArrangedSubview(moveToPreviousMonthButton)
        titleStackView.addArrangedSubview(titleMonthLabel)
        titleStackView.addArrangedSubview(moveToNextMonthButton)
    
        self.view.addSubview(titleStackView)
        self.view.addSubview(segmentedControl)
        
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            titleStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            
            segmentedControl.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 13),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            
        ])
        
        let initialViewController = exerciseRecordVC
        addChild(initialViewController)
        initialViewController.didMove(toParent: self)
        currentVC = initialViewController
    }
    
    
    override func addChild(_ viewController: UIViewController) {
        view.addSubview(viewController.view)
        
        let safeArea = view.safeAreaLayoutGuide
        
        // 레이아웃 설정
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            viewController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
}




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
    
    
    
    private lazy var titleMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "2024년 7월"
        label.font = UIFont.font(.pretendardMedium, ofSize: 16)
        label.textColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTitleMonthLabel))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var foldingImage: UIImageView = {
        let imageView = UIImageView()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let symbolName =  "chevron.down"
        let symbol = UIImage(systemName: symbolName, withConfiguration: symbolConfig)
        imageView.image = symbol
        
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        
        setupNavigationBar()
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
        dateFormatter.dateFormat = "yyyy년 M월"
        
        if let date = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth)) {
            titleMonthLabel.text = dateFormatter.string(from: date)
        }
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
        

        
    }
    
    @objc private func didTapTitleMonthLabel() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let yearMonthPickerVC = MonthPickerViewController(defaultYear: currentYear, defaultMonth: currentMonth)
        
        // YearMonthPickerViewController에서 선택한 날짜를 받아 처리하는 핸들러 설정
        yearMonthPickerVC.yearMonthSelectionHandler = { [weak self] year, month in
            guard let self = self else { return }
            
            // ViewModel에 연도와 월 업데이트
            self.reportsVM.updateYearAndMonth(year: year, month: month)
            self.inBodyVM.updateYearAndMonth(year: year, month: month)
            
            // 타이틀 레이블 업데이트
            updateTitleMonthLabel()
            
            // 운동 기록 화면 업데이트
            self.exerciseRecordVC.fetchDataAndUpdateUI()
        }
        
        // YearMonthPickerViewController 표시
        yearMonthPickerVC.modalPresentationStyle = .pageSheet
        yearMonthPickerVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(yearMonthPickerVC, animated: true, completion: nil)
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
        self.view.backgroundColor = .color1E1E1E
        
        self.view.addSubview(titleMonthLabel)
        self.view.addSubview(segmentedControl)
        self.view.addSubview(foldingImage)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            titleMonthLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 3),
            titleMonthLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            
            foldingImage.centerYAnchor.constraint(equalTo: titleMonthLabel.centerYAnchor),
            foldingImage.leadingAnchor.constraint(equalTo: titleMonthLabel.trailingAnchor, constant: 6),
            
            
            segmentedControl.topAnchor.constraint(equalTo: titleMonthLabel.bottomAnchor, constant: 13),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
        ])
        
        let initialViewController = exerciseRecordVC
        addChild(initialViewController)
        initialViewController.didMove(toParent: self)
        currentVC = initialViewController
    }
    
    private func setupNavigationBar() {
        self.title = "월간 리포트"
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .color1E1E1E
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                .font: UIFont(name: "Pretendard-Semibold", size: 20) as Any
            ]
            appearance.shadowColor = nil
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    
    override func addChild(_ viewController: UIViewController) {
        view.addSubview(viewController.view)
        
        let safeArea = view.safeAreaLayoutGuide
        
        // 레이아웃 설정
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            viewController.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)

        ])
    }
    
}

extension ReportsViewController {
    
    
    // 버튼 삭제로 인해 사용 안함
//    private func didTapPreviousMonth() {
//        let newYear: Int
//        let newMonth: Int
//        
//        if currentMonth == 1 {
//            newYear = currentYear - 1
//            newMonth = 12
//        } else {
//            newYear = currentYear
//            newMonth = currentMonth - 1
//        }
//        
//        reportsVM.updateYearAndMonth(year: newYear, month: newMonth)
//        inBodyVM.updateYearAndMonth(year: newYear, month: newMonth)
//        
//        
//        updateTitleMonthLabel()
//        exerciseRecordVC.fetchDataAndUpdateUI()
//    }
//    
//    private func didTapNextMonth() {
//        let newYear: Int
//        let newMonth: Int
//        
//        if currentMonth == 12 {
//            newYear = currentYear + 1
//            newMonth = 1
//        } else {
//            newYear = currentYear
//            newMonth = currentMonth + 1
//        }
//        
//        reportsVM.updateYearAndMonth(year: newYear, month: newMonth)
//        inBodyVM.updateYearAndMonth(year: newYear, month: newMonth)
//        
//        
//        updateTitleMonthLabel()
//        exerciseRecordVC.fetchDataAndUpdateUI()
//    }
    
}




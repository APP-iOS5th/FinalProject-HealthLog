//
//  MonthPickerViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/5/24.
//

import UIKit

class MonthPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let realm = RealmManager.shared.realm
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
//        picker.backgroundColor = .color2F2F2F
        picker.backgroundColor = .clear
        picker.tintColor = .white
        picker.layer.cornerRadius = 12 // 원하는 반경으로 설정
        picker.layer.masksToBounds = true // 경계 안쪽의 자식 뷰들도 모서리에 맞게 잘림
        return picker
    }()
    
    private lazy var datePickerLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜를 선택해 주세요."
        label.font = UIFont.font(.pretendardRegular, ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        
        // 배경색 설정
        button.titleLabel?.textColor = .white
        button.backgroundColor = .colorAccent
        
        // 코너 반경을 버튼 높이의 절반으로 설정하여 캡슐 모양 만들기
        button.layer.cornerRadius = 25
        
        // 버튼 크기 설정 (넓고 긴 모양으로)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    private lazy var selectButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("선택", for: .normal)
//        button.titleLabel?.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
//        button.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
//        button.setTitleColor(.white, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    
    private var years: [Int] = []
    private let months: [Int] = Array(1...12)
    private var selectedYear: Int
    private var selectedMonth: Int
    
    var yearMonthSelectionHandler: ((Int, Int) -> Void)?
    
    init(defaultYear: Int, defaultMonth: Int) {
        self.selectedYear = defaultYear
        self.selectedMonth = defaultMonth
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .color1E1E1E
        
        view.addSubview(pickerView)
        view.addSubview(selectButton)
//        view.addSubview(cancelButton)
//        view.addSubview(datePickerLabel)
        
        
        setupConstraints()
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return 285
            })]
            sheet.prefersGrabberVisible = false
        }
        
        
        // Realm에서 데이터를 가져와서 초기화
        let fetchedData = fetchYearsInRange
        self.years = fetchedData()
        
        // PickerView의 기본 선택값 설정
        if let yearIndex = years.firstIndex(of: selectedYear) {
            pickerView.selectRow(yearIndex, inComponent: 0, animated: false)
            if let monthIndex = months.firstIndex(of: selectedMonth) {
                pickerView.selectRow(monthIndex, inComponent: 1, animated: false)
            }
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48), // 좌우 패딩을 고려하여 넓이 설정
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -13),
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48),
            
            
        ])
    }
    
    @objc private func didTapSelectButton() {
        yearMonthSelectionHandler?(selectedYear, selectedMonth)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return months.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        if component == 0 {
            label.text = "\(years[row])년"
        } else {
            label.text = "\(months[row])월"
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedYear = years[row]
        case 1:
            selectedMonth = months[row]
        default:
            break
        }
    }
    
    private func fetchYearsInRange() -> [Int] {
        guard let realm = realm else { return [] }
        let schedules = realm.objects(Schedule.self)
        
        guard let firstSchedule = schedules.first,
              let lastSchedule = schedules.last else {
            return []
        }
        
        let calendar = Calendar.current
        
        // 첫 데이터와 마지막 데이터의 연도와 월 추출
        let firstYear = calendar.component(.year, from: firstSchedule.date)
        let lastYear = calendar.component(.year, from: lastSchedule.date)
        
        
        var years = Set<Int>()
        
        // 첫 데이터의 연도부터 마지막 데이터의 연도까지 반복
        for year in firstYear...lastYear {
            years.insert(year)
        }
        
        return Array(years).sorted()
    }

}

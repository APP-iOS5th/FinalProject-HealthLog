//
//  WeightRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class WeightRecordViewController: UIViewController {
    private let realm = RealmManager.shared.realm

    private lazy var inbodyinfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인바디 정보 입력", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .colorSecondary
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(inputModalView), for: .touchUpInside)
        
        // 커스텀 폰트 적용
        let customfont = UIFont.font(.pretendardSemiBold, ofSize: 18)
        button.titleLabel?.font = customfont
        
        return button
    }()
    
    private lazy var weightBox = InfoBox(title: "몸무게", value: "84", unit: "kg")
    private lazy var musclesBox = InfoBox(title: "골격근량", value: "84", unit: "kg")  // 근골격량 or 골격근량
    private lazy var fatBox = InfoBox(title: "체지방률", value: "84", unit: "%")
    
    // 인바디 기록을 담는 배열
    private var inbodyRecords: [InBody] = []
    
    // 화면이 다시 나타날 때마다 호출
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchInbodyData()
    }
    
    // Realm에서 데이터를 불러와 UI에 반영
    private func fetchInbodyData() {
        guard let realm = realm else { return } // realm 에러처리 때문에 이부분 코드 삽입했습니다 _ 허원열
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .month, value: -1, to: now)! // 1개월 전
        let endDate = now

        let inbodyRecords = Array(realm.objects(InBody.self)
            .filter("date >= %@ AND date <= %@", startDate, endDate)
            .sorted(byKeyPath: "date", ascending: false))
           
        if let latestRecord = inbodyRecords.first {
            updateInfoBoxes(with: latestRecord)
           }
       }

       private func updateInfoBoxes(with record: InBody) {
           weightBox.updateValue(String(format: "%.0f", record.weight))
           musclesBox.updateValue(String(format: "%.0f", record.muscleMass))
           fatBox.updateValue(String(format: "%.0f", record.bodyFat))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        //배경색 변경
        view.backgroundColor = UIColor(named: "ColorPrimary")
        
        // UI에 추가
        view.addSubview(inbodyinfoButton)
        view.addSubview(weightBox)
        view.addSubview(musclesBox)
        view.addSubview(fatBox)
        
        // Auto Layout 설정
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false
        weightBox.translatesAutoresizingMaskIntoConstraints = false
        musclesBox.translatesAutoresizingMaskIntoConstraints = false
        fatBox.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            inbodyinfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inbodyinfoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inbodyinfoButton.widthAnchor.constraint(equalToConstant: 345),
            inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44),
            
            weightBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            weightBox.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightBox.widthAnchor.constraint(equalToConstant: 94),
            weightBox.heightAnchor.constraint(equalToConstant: 88),
            
            musclesBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            musclesBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            musclesBox.widthAnchor.constraint(equalToConstant: 94),
            musclesBox.heightAnchor.constraint(equalToConstant: 88),
            
            fatBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            fatBox.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fatBox.widthAnchor.constraint(equalToConstant: 94),
            fatBox.heightAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    // MARK: - InfoBox
    
    class InfoBox: UIView {
        private let titleLabel: UILabel
        private let valueLabel: UILabel
        private let unitLabel: UILabel
        
        init(title: String, value: String, unit: String) {
            titleLabel = UILabel()
            valueLabel = UILabel()
            unitLabel = UILabel()
            
            super.init(frame: .zero)
            
            setupView(title: title, value: value, unit: unit)
        }
        required init(coder: NSCoder) {
            fatalError("init(coder:)")
        }
      
      private func setupView(title: String, value: String, unit: String) {
          backgroundColor = .color2F2F2F
          layer.cornerRadius = 7
          
          titleLabel.text = title
          titleLabel.textColor = .white
          titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
          titleLabel.textAlignment = .center
          
          let dividerView = UIView()
          dividerView.backgroundColor = .color3E3E3E
          
          valueLabel.text = value
          valueLabel.textColor = .white
          valueLabel.font = UIFont.font(.pretendardBold, ofSize: 25)
          valueLabel.textAlignment = .center
          
          unitLabel.text = unit
          unitLabel.textColor = .white
          unitLabel.font = UIFont.font(.pretendardRegular, ofSize: 12)
          unitLabel.textAlignment = .center
          
          addSubview(titleLabel)
          addSubview(dividerView)
          addSubview(valueLabel)
          addSubview(unitLabel)
          
          titleLabel.translatesAutoresizingMaskIntoConstraints = false
          dividerView.translatesAutoresizingMaskIntoConstraints = false
          valueLabel.translatesAutoresizingMaskIntoConstraints = false
          unitLabel.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
              titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
              titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              
              dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
              dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
              dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
              dividerView.heightAnchor.constraint(equalToConstant: 1),
              
              valueLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8),
              valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              
              unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 2),
              unitLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -3),
          ])
      }
      
      func updateValue(_ newValue: String) {
          valueLabel.text = newValue
      }
  }
    
    // MARK: - Actions
    @objc private func inputModalView() {
        let vc = WeightRecordModalViewController()
        vc.modalPresentationStyle = .formSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]  // 모달 크기 지정
            sheet.prefersGrabberVisible = true  // 시트 상단에 그래버 표시
            sheet.preferredCornerRadius = 32
        }
        present(vc, animated: true, completion: nil)
    }
}

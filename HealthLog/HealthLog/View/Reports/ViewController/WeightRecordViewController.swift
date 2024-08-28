//
//  WeightRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//
import Combine
import RealmSwift
import UIKit
import SwiftUI

class WeightRecordViewController: UIViewController {
    // MARK: - (youngwoo)
    // youngwoo - 뷰모델 이 파일 맨 밑
    let weightRecordViewModel = WeightRecordViewModel()
    
    
    
    // MARK: - (youngwoo)
    // youngwoo - WeightRecordViewController 종료시, 구독 Bind 해제
    private var cancellables = Set<AnyCancellable>()
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // youngwoo - 04. setupBindings을 viewDidLoad에서 실행
        // 이제 자동으로 계속 감지함
        setupBindings()
        
        
        // MARK: chartView (SwiftUI) 삽입
        let inBodyChartView = InBodyChartView()
        let hostingController = UIHostingController(rootView: inBodyChartView)
        
        self.addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: weightBox.bottomAnchor, constant: 8),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
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
    
    // MARK: - (youngwoo) Bindings
    // youngwoo - 03. UI에서 업데이트할 코드를 Init에 서 호출
    // 한번 구독 Bind 걸어두면 자동으로 작동함
    private func setupBindings() {
        
        // youngwoo - Combine Published 변수 inbodyRecords 변경 구독
        // DB 값 변경으로 뷰모델의 inbodyRecords가 변경될때 마다 UI에 값 업데이트
        weightRecordViewModel.$inbodyRecords
            .sink { inbodyRecords in
                if let record = inbodyRecords.first {
                    self.weightBox.updateValue(
                        String(format: "%.0f", record.weight))
                    self.musclesBox.updateValue(
                        String(format: "%.0f", record.muscleMass))
                    self.fatBox.updateValue(
                        String(format: "%.0f", record.bodyFat))
                }
            }
            .store(in: &cancellables)
    }
    
}


// MARK: (youngwoo) WeightRecordViewModel
// youngwoo - inbody가 DB에서 변경될때, Published 변수에 그대로 전달
class WeightRecordViewModel {
    
    // MARK: (youngwoo) RealmCombine 01.
    // RealmCombine 01. observeRealmData 함수에서 observe 쓰기 위해 사용하는 변수
    private var inbodyNotificationToken: NotificationToken?
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var inbodyRecords: [InBody] = []
    
    // Realm 인스턴스를 저장할 속성 추가
     private var realm: Realm?
    
    init() {
        print("WeightRecordViewModel")
        // Realm 인스턴스 초기화
               self.realm = RealmManager.shared.realm
        
        // 한번 걸어두면 inbodyNotificationToken와 observe에 의해 자동으로 실행됨
        observeRealmData()
    }
    
    // MARK: (youngwoo) RealmCombine 02. init에 쓸 observe 함수
    // RealmCombine 02. inbody가 DB에서 변경될때, Published 변수에 그대로 전달하도록 세팅
    // observe 걸어서 inbodyNotificationToken에 담아두면 자동으로 작동함
    private func observeRealmData() {
        guard let realm = realm else { return }
        
        // MARK: (youngwoo) RealmCombine 03. 데이터 불러옴
        // 일단 filter 삭제. 최신 값이 안불러와짐.
        // 제가 짠게 아니라 모르겠지만 sort에 fisrt면 충분할수도?
        let results = realm.objects(InBody.self)
            .sorted(byKeyPath: "date", ascending: false)
    
        // result에 담은 Realm DB 데이터를 observe로 감시, DB 값 변경시 안에 있는 실행
        inbodyNotificationToken = results.observe { [weak self] changes in
            switch changes {
                    
                case .initial(let collection):
                    print("results.observe - initial") // 첫 실행시 코드 실행

                    // Realm의 Results<Inbody>타입을 Array로 일반 [Inbody] 타입화
                    // Combine에 DB 데이터를 넣기
                    self?.inbodyRecords = Array(collection)
                    print(self?.inbodyRecords ?? [])
                    
                    
                case .update(let collection, _, _, _):
                    print("results.observe - update")  // 값 변경시 코드 실행
                    
                    // Realm의 Results<Inbody>타입을 Array로 일반 [Inbody] 타입화
                    // Combine에 DB 데이터를 넣기
                    self?.inbodyRecords = Array(collection)
                    print(self?.inbodyRecords ?? [])
                    
                    
                case .error(let error):
                    print("results.observe - error: \(error)")
            }
        }
    }
}

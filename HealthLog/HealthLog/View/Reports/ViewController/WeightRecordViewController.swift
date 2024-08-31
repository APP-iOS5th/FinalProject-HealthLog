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
    
    private var currentYear: Int = Calendar.current.component(.year, from: Date())
    private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    private var viewModel = InBodyChartViewModel()
    private var hostingController: UIHostingController<InBodyChartView>?
    
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
    
    private lazy var weightBox = InfoBoxView(title: "몸무게", value: "84", unit: "kg")
    private lazy var musclesBox = InfoBoxView(title: "골격근량", value: "84", unit: "kg")
    private lazy var fatBox = InfoBoxView(title: "체지방률", value: "84", unit: "%")
    
    private var inbodyRecords: [InBody] = []   // 인바디 기록을 담는 배열
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()   // youngwoo - 04. setupBindings을 viewDidLoad에서 실행, 자동으로 계속 감지함
        
        fetchInBodyDataForMonth(year: currentYear, month: currentMonth)
        
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "ColorPrimary")
        
        // MARK: chartView (SwiftUI) 삽입
        let chartView = InBodyChartView(viewModel: viewModel)
        hostingController = UIHostingController(rootView: chartView)
        hostingController?.view.backgroundColor = .clear
        
        
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        contentView.addSubview(inbodyinfoButton)
        contentView.addSubview(weightBox)
        contentView.addSubview(musclesBox)
        contentView.addSubview(fatBox)
        contentView.addSubview(hostingController!.view)
        
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false
        weightBox.translatesAutoresizingMaskIntoConstraints = false
        musclesBox.translatesAutoresizingMaskIntoConstraints = false
        fatBox.translatesAutoresizingMaskIntoConstraints = false


        hostingController?.view.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            inbodyinfoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            inbodyinfoButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            inbodyinfoButton.widthAnchor.constraint(equalToConstant: 345),
            inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44),
            
            weightBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            weightBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weightBox.widthAnchor.constraint(equalToConstant: 94),
            weightBox.heightAnchor.constraint(equalToConstant: 88),
            
            musclesBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            musclesBox.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            musclesBox.widthAnchor.constraint(equalToConstant: 94),
            musclesBox.heightAnchor.constraint(equalToConstant: 88),
            
            fatBox.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 13),
            fatBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            fatBox.widthAnchor.constraint(equalToConstant: 94),
            fatBox.heightAnchor.constraint(equalToConstant: 88),
            
            hostingController!.view.topAnchor.constraint(equalTo: fatBox.bottomAnchor, constant: 12),
            hostingController!.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // ScrollView 제약 조건 설정 (UI 요소들이 모두 contentView에 추가된 후 설정)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
    }
    
    
    
    
    // MARK: - Actions
    @objc private func inputModalView() {
        let vc = WeightRecordModalViewController()
        vc.modalPresentationStyle = .formSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32
        }
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - (youngwoo) Bindings
    // youngwoo - 03. UI에서 업데이트할 코드를 Init에 서 호출
    private func setupBindings() {
        
        // youngwoo - Combine Published 변수 inbodyRecords 변경 구독
        viewModel.$inbodyRecords
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
    
    
    // MARK: (원열) 특정 월 단위 데이터 fetch
    func fetchInBodyDataForMonth(year: Int, month: Int) {
        let startDate = makeDate(year: year, month: month, day: 1)
        let endDate = makeDate(year: year, month: month + 1, day: 1).addingTimeInterval(-1)
        
        viewModel.loadData(for: startDate, to: endDate)
    }
    
    
    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    
    
//    // MARK: (youngwoo) WeightRecordViewModel
//    class WeightRecordViewModel {
//        // MARK: (youngwoo) RealmCombine 01.
//        // RealmCombine 01. observeRealmData 함수에서 observe 쓰기 위해 사용하는 변수
////        private var inbodyNotificationToken: NotificationToken?
////        private var cancellables = Set<AnyCancellable>()
//        @Published var inbodyRecords: [InBody] = []
////        private var realm: Realm?
//        init() {
////            self.realm = RealmManager.shared.realm
//            
//            observeRealmData()  // inbodyNotificationToken와 observe에 의해 자동으로 실행됨
//        }
//        
//        // MARK: (youngwoo) RealmCombine 02. init에 쓸 observe 함수
//        // RealmCombine 02. inbody가 DB에서 변경될때, Published 변수에 그대로 전달하도록 세팅
//        private func observeRealmData() {
//            guard let realm = realm else { return }
//            
//            // MARK: (youngwoo) RealmCombine 03. 데이터 불러옴
//            let results = realm.objects(InBody.self)
//                .sorted(byKeyPath: "date", ascending: false)
//            
//            // result에 담은 Realm DB 데이터를 observe로 감시, DB 값 변경시 안에 있는 실행
//            inbodyNotificationToken = results.observe { [weak self] changes in
//                switch changes {
//                case .initial(let collection):
//                    self?.inbodyRecords = Array(collection)
//                    
//                    //                    print(self?.inbodyRecords ?? [])
//                case .update(let collection, _, _, _):
//                    self?.inbodyRecords = Array(collection)
//                case .error(let error):
//                    print("results.observe - error: \(error)")
//                }
//            }
//        }
//    }
}

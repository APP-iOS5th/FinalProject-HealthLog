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
    
    private var inBodyVM: InBodyChartViewModel
    private var hostingController: UIHostingController<InBodyChartView>?
    
    init(inBodyVM: InBodyChartViewModel) {
        self.inBodyVM = inBodyVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - (youngwoo)
    // youngwoo - WeightRecordViewController 종료시, 구독 Bind 해제
    private var cancellables = Set<AnyCancellable>()
    
    private let realm = RealmManager.shared.realm
    
    
    private lazy var inbodyinfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인바디 정보 입력", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .colorAccent
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(inputModalView), for: .touchUpInside)
        
        // 커스텀 폰트 적용
        let customfont = UIFont.font(.pretendardSemiBold, ofSize: 18)
        button.titleLabel?.font = customfont
        
        return button
    }()
    
    private lazy var inbodyinfoLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 인바디 정보"
        label.textColor = .white
        label.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var dateinbodyLable: UILabel = {
        let label = UILabel()
        label.textColor = .color969696
        label.font = UIFont.font(.pretendardSemiBold, ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    private let infoBoxView = InfoBoxView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()   // youngwoo - 04. setupBindings을 viewDidLoad에서 실행, 자동으로 계속 감지함
        updateRecentInbodyDate()
        
    }

    
    func setupUI() {
        view.backgroundColor = .color1E1E1E
        view.addSubview(infoBoxView)

        // MARK: chartView (SwiftUI) 삽입
        let chartView = InBodyChartView(viewModel: inBodyVM)
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
        contentView.addSubview(inbodyinfoLabel)
        contentView.addSubview(dateinbodyLable)
        contentView.addSubview(hostingController!.view)
        
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false
        inbodyinfoLabel.translatesAutoresizingMaskIntoConstraints = false
        dateinbodyLable.translatesAutoresizingMaskIntoConstraints = false


        hostingController?.view.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
//            inbodyinfoLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
//            inbodyinfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            dateinbodyLable.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateinbodyLable.leadingAnchor.constraint(equalTo: inbodyinfoLabel.trailingAnchor, constant: 15),
            
            infoBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoBoxView.topAnchor.constraint(equalTo: inbodyinfoLabel.bottomAnchor, constant: 17),
            infoBoxView.heightAnchor.constraint(equalToConstant: 100),
            
            inbodyinfoButton.topAnchor.constraint(equalTo: infoBoxView.bottomAnchor, constant: 230),
            inbodyinfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            inbodyinfoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44),
            
            hostingController!.view.topAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 20),
            hostingController!.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // ScrollView 제약 조건 설정 (UI 요소들이 모두 contentView에 추가된 후 설정)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
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
        inBodyVM.$inbodyRecords
            .sink { [weak self] inbodyRecords in
                guard let self = self else { return }
                
                if let record = inbodyRecords.first {
                    self.infoBoxView.updateValues(
                        weight: Double(record.weight),
                        muscleMass: Double(record.muscleMass),
                        bodyFat: Double(record.bodyFat)
                    )
                }
                self.updateRecentInbodyDate()
            }
            .store(in: &cancellables)
    }
    
    private func updateRecentInbodyDate() {
        guard let realm = realm else {
            dateinbodyLable.text = ""
            return
        }
        
        if let recentRecord = realm.objects(InBody.self)
            .sorted(byKeyPath: "date", ascending: false)
            .first {
            let formatter = DateFormatter()
            formatter.dateFormat = "(yyyy년 MM월 dd일)"
            dateinbodyLable.text = formatter.string(from: recentRecord.date)
        } else {
            dateinbodyLable.text = ""
        }
    }
    

    
}

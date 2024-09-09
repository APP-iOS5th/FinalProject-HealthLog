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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }

    
    func setupUI() {
        view.backgroundColor = .color1E1E1E
        
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
        
        contentView.addSubview(hostingController!.view)


        hostingController?.view.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            
            hostingController!.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            hostingController!.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingController!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hostingController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // ScrollView 제약 조건 설정 (UI 요소들이 모두 contentView에 추가된 후 설정)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
    }
    
    
//    // MARK: - Actions
//    @objc private func inputModalView() {
//        let vc = WeightRecordModalViewController()
//        vc.modalPresentationStyle = .formSheet
//        
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = [.medium()]
//            sheet.prefersGrabberVisible = true
//            sheet.preferredCornerRadius = 32
//        }
//        present(vc, animated: true, completion: nil)
//    }
//    
//    // MARK: - (youngwoo) Bindings
//    // youngwoo - 03. UI에서 업데이트할 코드를 Init에 서 호출
//    private func setupBindings() {
//        
//        // youngwoo - Combine Published 변수 inbodyRecords 변경 구독
//        inBodyVM.$inbodyRecords
//            .sink { [weak self] inbodyRecords in
//                guard let self = self else { return }
//                
//                if let record = inbodyRecords.first {
//                    self.weightBox.updateValue(
//                        String(format: "%.1f", record.weight))
//                    self.musclesBox.updateValue(
//                        String(format: "%.1f", record.muscleMass))
//                    self.fatBox.updateValue(
//                        String(format: "%.1f", record.bodyFat))
//                }
//                self.updateRecentInbodyDate()
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func updateRecentInbodyDate() {
//        guard let realm = realm else {
//            dateinbodyLable.text = ""
//            return
//        }
//        
//        if let recentRecord = realm.objects(InBody.self)
//            .sorted(byKeyPath: "date", ascending: false)
//            .first {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "(yyyy년 MM월 dd일)"
//            dateinbodyLable.text = formatter.string(from: recentRecord.date)
//        } else {
//            dateinbodyLable.text = ""
//        }
//    }
    

    
}

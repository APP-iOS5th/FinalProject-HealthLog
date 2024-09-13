//
//  MyAccountViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/10/24.
//

import UIKit
import Combine

class MyInfomationViewController: UIViewController {
    
    private let viewModel = MyInfomationViewModel()
    private let realm = RealmManager.shared.realm
    private var cancellables = Set<AnyCancellable>()
    
    private let userInfoView = UserInfoView()
    private let infoBoxView = InfoBoxView()
    
    // MARK: Inbody Group
    private lazy var inbodyinfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("인바디 정보 입력", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .colorAccent
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(inputModalView), for: .touchUpInside)
        
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
    
    // MARK: dataManagementGroup
    private lazy var dataManagementRollbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .colorSecondary
        button.layer.cornerRadius = 12
        
        button.addAction(UIAction { [weak self] _ in
            let vc = DataManagementViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "데이터 관리"
        titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 16)
        button.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(
            equalTo: button.centerYAnchor)
        .isActive = true
        titleLabel.leadingAnchor.constraint(
            equalTo: button.leadingAnchor, constant: 16)
        .isActive = true
        
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "chevron.right")
        arrowImage.tintColor = .white
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 16, weight: .medium)
        arrowImage.preferredSymbolConfiguration = configuration
        button.addSubview(arrowImage)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        arrowImage.centerYAnchor.constraint(
            equalTo: button.centerYAnchor)
        .isActive = true
        arrowImage.trailingAnchor.constraint(
            equalTo: button.trailingAnchor, constant: -16)
        .isActive = true
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        setupBindings()
        updateRecentInbodyDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupUI() {
        
        self.title = "내 정보"
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
        
        self.view.backgroundColor = .color1E1E1E
        
        let backbarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbarButtonItem
        
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
        contentView.addSubview(infoBoxView)
        
        contentView.addSubview(userInfoView)
        
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false
        inbodyinfoLabel.translatesAutoresizingMaskIntoConstraints = false
        dateinbodyLable.translatesAutoresizingMaskIntoConstraints = false

        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        infoBoxView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                userInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                userInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                userInfoView.heightAnchor.constraint(equalToConstant: 80),
                
                inbodyinfoLabel.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 20),
                inbodyinfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
                
                dateinbodyLable.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 23),
                dateinbodyLable.leadingAnchor.constraint(equalTo: inbodyinfoLabel.trailingAnchor, constant: 8),
                
                infoBoxView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                infoBoxView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                infoBoxView.topAnchor.constraint(equalTo: inbodyinfoLabel.bottomAnchor, constant: 13),
                
                inbodyinfoButton.topAnchor.constraint(equalTo: infoBoxView.bottomAnchor, constant: 13),
                inbodyinfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                inbodyinfoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44),
            ])
        
        // MARK: dataManagementGroup
        
        contentView.addSubview(dataManagementRollbackButton)
        dataManagementRollbackButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dataManagementRollbackButton.topAnchor.constraint(
                equalTo: inbodyinfoButton.bottomAnchor,
                constant: 50),
            dataManagementRollbackButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            dataManagementRollbackButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            dataManagementRollbackButton.heightAnchor.constraint(
                equalToConstant: 44),
        ])
        
        // MARK: contentView's last view setting
        
        contentView.bottomAnchor.constraint(
            equalTo: dataManagementRollbackButton.bottomAnchor,
            constant: 20)
        .isActive = true
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
    
//    @objc private func tapDataManagementRollbackButton() {
//        let alertController = UIAlertController(
//            title: "데이터를 초기화 하시겠습니까?",
//            message: "지금까지 작성한 데이터가 모두 삭제됩니다.",
//            preferredStyle: .alert
//        )
//        
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        let confirmAction = UIAlertAction(title: "초기화", style: .destructive) {
//            [weak self] _ in self?.resetData()
//        }
//        
//        alertController.addAction(cancelAction)
//        alertController.addAction(confirmAction)
//        
//        present(alertController, animated: true, completion: nil)
//    }
    
    
    // MARK: - (youngwoo) Bindings
    // youngwoo - 03. UI에서 업데이트할 코드를 Init에 서 호출
    private func setupBindings() {
        
        // youngwoo - Combine Published 변수 inbodyRecords 변경 구독
        viewModel.$inbodyRecords
            .sink { [weak self] inbodyRecords in
                guard let self = self else { return }
                
                if let record = inbodyRecords.first {
                    self.infoBoxView.updateValues(
                        weight: Double(record.weight),
                        muscleMass: Double(record.muscleMass),
                        bodyFat: Double(record.bodyFat)
                    )
                } else {
                    self.infoBoxView.updateValues(
                        weight: 0.0,
                        muscleMass: 0.0,
                        bodyFat: 0.0
                    )
                }
                self.updateRecentInbodyDate()
            }
            .store(in: &cancellables)
        
        
        viewModel.$daysCount
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.userInfoView.configure(
                    image: UIImage(systemName: "person.circle.fill"),
                    name: "사용자",
                    days: count)
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

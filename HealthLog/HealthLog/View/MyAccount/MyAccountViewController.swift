//
//  MyAccountViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 9/10/24.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    let userInfoView = UserInfoView()
    
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
    
    
    private lazy var weightBox = InfoBoxView(title: "몸무게", value: "0.0", unit: "kg")
    private lazy var musclesBox = InfoBoxView(title: "골격근량", value: "0.0", unit: "kg")
    private lazy var fatBox = InfoBoxView(title: "체지방률", value: "0.0", unit: "%")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    func setupUI() {
        
        userInfoView.configure(image: UIImage(systemName: "person.circle.fill"), name: "홍길동")
        
        self.view.backgroundColor = .color1E1E1E
        
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
        contentView.addSubview(weightBox)
        contentView.addSubview(musclesBox)
        contentView.addSubview(fatBox)
        
        contentView.addSubview(userInfoView)
        
        inbodyinfoButton.translatesAutoresizingMaskIntoConstraints = false
        inbodyinfoLabel.translatesAutoresizingMaskIntoConstraints = false
        dateinbodyLable.translatesAutoresizingMaskIntoConstraints = false
        weightBox.translatesAutoresizingMaskIntoConstraints = false
        musclesBox.translatesAutoresizingMaskIntoConstraints = false
        fatBox.translatesAutoresizingMaskIntoConstraints = false
        
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        
                
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
                
                contentView.bottomAnchor.constraint(equalTo: inbodyinfoButton.bottomAnchor, constant: 20),
                
                userInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                userInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                userInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                userInfoView.heightAnchor.constraint(equalToConstant: 80),
                
      
                inbodyinfoLabel.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 13),
                inbodyinfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                

                dateinbodyLable.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 13),
                dateinbodyLable.leadingAnchor.constraint(equalTo: inbodyinfoLabel.trailingAnchor, constant: 8),
                

                weightBox.topAnchor.constraint(equalTo: inbodyinfoLabel.bottomAnchor, constant: 13),
                weightBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                weightBox.widthAnchor.constraint(equalToConstant: 94),
                weightBox.heightAnchor.constraint(equalToConstant: 88),
                

                musclesBox.topAnchor.constraint(equalTo: inbodyinfoLabel.bottomAnchor, constant: 13),
                musclesBox.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                musclesBox.widthAnchor.constraint(equalToConstant: 94),
                musclesBox.heightAnchor.constraint(equalToConstant: 88),
                

                fatBox.topAnchor.constraint(equalTo: inbodyinfoLabel.bottomAnchor, constant: 13),
                fatBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                fatBox.widthAnchor.constraint(equalToConstant: 94),
                fatBox.heightAnchor.constraint(equalToConstant: 88),
                

                inbodyinfoButton.topAnchor.constraint(equalTo: weightBox.bottomAnchor, constant: 13),
                inbodyinfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                inbodyinfoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                inbodyinfoButton.heightAnchor.constraint(equalToConstant: 44),
                

                
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
}

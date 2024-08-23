//
//  WeightRecordViewController.swift
//  HealthLog
//
//  Created by wonyoul heo on 8/13/24.
//

import UIKit

class WeightRecordViewController: UIViewController {

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
    
    // 인바디 정보 박스
    private func InfoBox(title: String, value: String, unit: String) -> UIView {
       let boxView = UIView()
       boxView.backgroundColor = .color2F2F2F
       boxView.layer.cornerRadius = 7
       
       let titleLabel = UILabel()
       titleLabel.text = title
       titleLabel.textColor = .white
       titleLabel.font = UIFont.font(.pretendardSemiBold, ofSize: 14)
       titleLabel.textAlignment = .center
       
       let dividerView = UIView()
       dividerView.backgroundColor = .color3E3E3E
    
       let valueLabel = UILabel()
       valueLabel.text = value
       valueLabel.textColor = .white
       valueLabel.font = UIFont.font(.pretendardBold, ofSize: 25)
       valueLabel.textAlignment = .center
       
       let unitLabel = UILabel()
       unitLabel.text = unit
       unitLabel.textColor = .white
       unitLabel.font = UIFont.font(.pretendardRegular, ofSize: 12)
       unitLabel.textAlignment = .center
        
       // boxView에 추가
       boxView.addSubview(titleLabel)
       boxView.addSubview(dividerView)
       boxView.addSubview(valueLabel)
       boxView.addSubview(unitLabel)
       
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
       dividerView.translatesAutoresizingMaskIntoConstraints = false
       valueLabel.translatesAutoresizingMaskIntoConstraints = false
       unitLabel.translatesAutoresizingMaskIntoConstraints = false
       
       NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 13),
           titleLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
           
           dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
           dividerView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 8),
           dividerView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -8),
           dividerView.heightAnchor.constraint(equalToConstant: 1),
           
           valueLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 8),
           valueLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
           
           unitLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 2),
           unitLabel.bottomAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: -3),
       ])
       
       return boxView
   }
    
    // MARK: - Actions
    @objc private func inputModalView() {
        let vc = WeightRecordModalViewController()
        vc.modalPresentationStyle = .formSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]  // 모달 크기 지정
            sheet.prefersGrabberVisible = true  // 시트 상단에 그래버 표시
            sheet.selectedDetentIdentifier = .medium  // 처음 크기 지정
            sheet.largestUndimmedDetentIdentifier = .large  //뒷 배경 흐리게 적용이 안됨
            sheet.preferredCornerRadius = 32
        }
        present(vc, animated: true, completion: nil)
    }
}

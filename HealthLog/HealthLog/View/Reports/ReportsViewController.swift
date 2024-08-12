//
//  ReportsViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class ReportsViewController: UIViewController {
    
    private var testLabel01: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Black", size: 16)
        label.textColor = UIColor(named: "ColorAccent")
        label.text = "폰트 테스트: Pretendard-Black"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var testLabel02: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Thin", size: 16)
        label.textColor = UIColor(named: "ColorAccent")
        label.text = "폰트 테스트: Pretendard-Thin"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //배경색 테스트
        view.backgroundColor = UIColor(named: "ColorPrimary")

        
        view.addSubview(testLabel01)
        view.addSubview(testLabel02)
    
        
        NSLayoutConstraint.activate([
            testLabel01.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel01.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            testLabel02.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel02.topAnchor.constraint(equalTo: testLabel01.bottomAnchor)
            
        ])
        
    }

}



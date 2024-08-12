//
//  RoutineViewController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/12/24.
//

import UIKit

class RoutinesViewController: UIViewController {

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "추가된 루틴이 없습니다."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        self.view.addSubview(textLabel)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 115),
            self.textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 108),
        ])
        
    }
}

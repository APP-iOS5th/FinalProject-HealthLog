//
//  RoutineAddNameViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/12/24.
//

import UIKit

class RoutineAddNameViewController: UIViewController {

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "루틴 이름을 정해주세요."
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupView()
        
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(textLabel)
        
        let safeArea = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 36)
            
        ])
        
        
    }
}

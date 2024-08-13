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
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let buttonAction = UIAction { _ in
            print("addButton 클릭")
            let routineAddNameViewController = RoutineAddNameViewController()
            self.navigationController?.pushViewController(routineAddNameViewController, animated: true)
        }
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "plus.app.fill")?.withTintColor(.white, renderingMode: .alwaysTemplate), primaryAction: buttonAction)
        barButton.tintColor = UIColor(named: "ColorAccent")
       return barButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    func setupView() {
        
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        self.title = "루틴"
        self.view.tintColor = .white
        
    
        
        let backbarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbarButtonItem
        
        //MARK: - addSubview
        self.view.addSubview(textLabel)
        
        
        self.navigationItem.rightBarButtonItem = self.addButton
        
        let safeArea = self.view.safeAreaLayoutGuide
        //MARK: - NSLayoutconstraint
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 115),
            self.textLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
        ])
        
    }
}


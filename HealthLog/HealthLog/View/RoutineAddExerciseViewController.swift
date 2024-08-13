//
//  RoutineAddExerciseViewController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit

class RoutineAddExerciseViewController: UIViewController {
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "운도을 추가해주세요."
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExercise")
        setupView()
    }
    

    func setupView() {
        self.view.backgroundColor = UIColor(named: "ColorPrimary")
        tabBarController?.tabBar.isHidden = true
        navigationController?.setupBarAppearance()
    }
    
}

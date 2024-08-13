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
        label.text = "운동을 추가해주세요."
        label.font =  UIFont.font(.pretendardSemiBold, ofSize: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Test를 위해 빌려옴
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "운동명 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: searchBar.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
            )
            textField.textColor = .white

            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
        }

        return searchBar
    }()
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ColorSecondary")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
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
        self.view.addSubview(textLabel)
        self.view.addSubview(dividerView)
        self.view.addSubview(searchBar)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.textLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant:  12),
            self.textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 24),
            self.dividerView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 13),
            self.dividerView.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor),
            self.dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
            self.searchBar.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor,constant: 13),
            self.searchBar.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor),
            self.searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            self.searchBar.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
        ])
        
    }
    
}

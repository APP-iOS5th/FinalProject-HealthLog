//
//  AddScheduleViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class AddScheduleViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    let getRoutineButton = UIButton()
    let dividerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "오늘 할 운동 추가"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(dismissView))
        
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        // UISearchController 설정
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "운동명 검색"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: searchController.searchBar.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexCode: "656565")]
            )
            
            textField.textColor = .white
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
        }
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        dividerView.backgroundColor = UIColor(hexCode: "29292A")
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dividerView)
        
        getRoutineButton.setTitle("루틴 불러오기", for: .normal)
        getRoutineButton.backgroundColor = UIColor(hexCode: "6500FF")
        getRoutineButton.layer.cornerRadius = 12
        getRoutineButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        getRoutineButton.translatesAutoresizingMaskIntoConstraints = false
        getRoutineButton.addTarget(self, action: #selector(routineButtonTapped), for: .touchUpInside)
        view.addSubview(getRoutineButton)
        
        setupConstraints()
        
        view.backgroundColor = UIColor(hexCode: "1E1E1E")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func routineButtonTapped() {
        let routineVC = RoutinesViewController()
        routineVC.modalPresentationStyle = .pageSheet
        self.present(routineVC, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            getRoutineButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 13),
            getRoutineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getRoutineButton.widthAnchor.constraint(equalToConstant: 345),
            getRoutineButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// UIColor extension 삭제 예정
extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

//
//  AddScheduleViewController.swift
//  HealthLog
//
//  Created by seokyung on 8/12/24.
//

import UIKit

class AddScheduleViewController: UIViewController {
    
    let searchBar = UISearchBar()
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
        
        searchBar.placeholder = "운동명 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: searchBar.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexCode: "656565")]
            )
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
        }
        view.addSubview(searchBar)
        
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
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func routineButtonTapped() {
        let routineVC = RoutinesViewController()
        routineVC.modalPresentationStyle = .pageSheet
        self.present(routineVC, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // 서치바 여백 수정 필요
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.widthAnchor.constraint(equalTo: getRoutineButton.widthAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            dividerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 13),
            dividerView.leadingAnchor.constraint(equalTo: getRoutineButton.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: getRoutineButton.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            getRoutineButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 13),
            getRoutineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getRoutineButton.widthAnchor.constraint(equalToConstant: 345),
            getRoutineButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// UIColor extension 하여 Hex 변경해주는 코드 (다같이 사용하면 좋을 듯)
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

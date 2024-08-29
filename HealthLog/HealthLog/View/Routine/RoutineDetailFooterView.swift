//
//  RoutineDetailFotterView.swift
//  HealthLog
//
//  Created by 어재선 on 8/29/24.
//

import UIKit

class RoutineDetailFooterView: UITableViewHeaderFooterView {
    static let cellId = "RoutineDetailFotterView"
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(divider)
        self.backgroundColor = .clear
        let padding: CGFloat = 24
        
        
        NSLayoutConstraint.activate([
         
            
            self.divider.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 3),
            self.divider.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            self.divider.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            self.divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

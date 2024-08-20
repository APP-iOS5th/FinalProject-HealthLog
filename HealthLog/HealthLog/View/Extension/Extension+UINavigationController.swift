//
//  Extension+UINavigationController.swift
//  HealthLog
//
//  Created by 어재선 on 8/13/24.
//

import UIKit

extension UINavigationController {
    func setupBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [ .font: UIFont.font(.pretendardSemiBold, ofSize: 20),
                                                .foregroundColor: UIColor.white ]
        appearance.titleTextAttributes = [.font: UIFont.font(.pretendardSemiBold, ofSize: 20),
                                          .foregroundColor: UIColor.white]
        
        appearance.backgroundColor = UIColor(named: "ColorPrimary")
        navigationBar.tintColor = .white
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
    
}



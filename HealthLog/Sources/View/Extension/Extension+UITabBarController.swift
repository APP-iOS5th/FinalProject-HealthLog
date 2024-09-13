//
//  Extension+UITabBarController.swift
//  HealthLog
//
//  Created by Jungjin Park on 8/29/24.
//

import UIKit

extension UITabBarController {
    func setupBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .color2F2F2F
        tabBar.barTintColor = .white
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
}

//
//  SceneDelegate.swift
//  HealthLog
//
//  Created by wonyoul heo on 7/25/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        if UserDefaults.standard.bool(forKey: "HasCompletedOnboarding") {
            print("SceneDelegate: Onboarding completed, showing main screen")
            let tabBarController = createTabBarController()
            window?.rootViewController = tabBarController
        } else {
            print("SceneDelegate: Showing onboarding screen")
            window?.rootViewController = OnboardingViewController()
        }
        
        self.window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
    }

    func createTabBarController() -> UITabBarController {
        let scheduleViewController = ScheduleViewController()
        let firstNC = UINavigationController(rootViewController: scheduleViewController)
        let routinesViewController = RoutinesViewController()
        let secondNC = UINavigationController(rootViewController: routinesViewController)
        secondNC.setupBarAppearance()
        let exercisesViewController = ExercisesViewController()
        let thirdNC = UINavigationController(rootViewController: exercisesViewController)
        
        let reportsViewController = ReportsViewController()
        let fourthNC = UINavigationController(rootViewController: reportsViewController)
        
        let myInformationViewController = MyInfomationViewController()
        let fifthNC = UINavigationController(rootViewController: myInformationViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNC, secondNC, thirdNC, fourthNC, fifthNC]
        
        firstNC.tabBarItem = UITabBarItem(title: "스케줄", image: UIImage(systemName: "calendar"), tag: 0)
        secondNC.tabBarItem = UITabBarItem(title: "루틴", image: UIImage(systemName: "repeat"), tag: 1)
        thirdNC.tabBarItem = UITabBarItem(title: "운동리스트", image: UIImage(systemName: "dumbbell"), tag: 2)
        fourthNC.tabBarItem = UITabBarItem(title: "리포트", image: UIImage(systemName: "chart.xyaxis.line"), tag: 3)
        fifthNC.tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(systemName: "person"), tag: 4)
        
        setupTabBarAppearance(tabBarController: tabBarController)
        
        return tabBarController
    }
    
    func setupTabBarAppearance(tabBarController: UITabBarController) {
        let tabBar = tabBarController.tabBar
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -20)
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowRadius = 15
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: -5, width: tabBar.frame.width, height: 5)
        topBorder.backgroundColor = UIColor.colorSecondary.cgColor
        tabBar.layer.addSublayer(topBorder)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


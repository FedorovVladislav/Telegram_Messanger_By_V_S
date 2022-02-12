//
//  ApplicationController.swift
//  tdlib-ios
//
//  Created by Anton Glezman on 28/09/2019.
//  Copyright © 2019 Anton Glezman. All rights reserved.
//

import UIKit

final class ApplicationController {
    
    static var window: UIWindow?

    
    static func showFirstController(_ window: UIWindow) {
        ApplicationController.window = window
        
        window.rootViewController = LoadingViewController()
    }
    
    static func showMain() {
        let tabBarVC = UITabBarController()
        
        let chatVC = ChatListViewController()
        let chatNavVC = initNavigationVC(viewController: chatVC)
        chatNavVC.tabBarItem.image = UIImage(systemName: "message")
        chatNavVC.tabBarItem.title = "Chats"
        
        let settingsVC = SettingsViewController()
        let settingsNavVC = initNavigationVC(viewController: settingsVC)
        settingsNavVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsNavVC.tabBarItem.title = "Settings"
        
        tabBarVC.setViewControllers([chatNavVC,settingsNavVC], animated: true)
        tabBarVC.tabBar.unselectedItemTintColor = .systemGray
        
        window?.rootViewController = tabBarVC
    }
    
    static func showAuth() {
        let vc = AuthViewController()
        sleep(1)

        window?.rootViewController = initNavigationVC(viewController: vc)
    }
    
    static private func initNavigationVC(viewController vc: UIViewController) -> UINavigationController {
        let navigationVC = UINavigationController()
        
        navigationVC.navigationBar.titleTextAttributes  =  [.foregroundColor: UIColor.white ]
        navigationVC.viewControllers = [vc]
        
        return navigationVC
    }
}

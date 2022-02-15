//
//  Router.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 14.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import UIKit


protocol RouterMain {
    var windows: UIWindow { get set }
    var tabBarController: UITabBarController { get set }
    var navigationController: UINavigationController { get set }
    var appBuilder: ApplicationBuilder { get set }
}

protocol RouterProtocol: RouterMain {
   func loadVC()
    func authCodeVC()
    func authNumberVC()
   // func contactVC()
    func chatListVC()
    func popBack()
    //func chatVC()
    //func settingVC()
}

class Router: RouterProtocol {
    
    func loadVC() {
        let vc = appBuilder.createLoadingModule(router: self)
        windows.rootViewController = vc
    }
    
    var tabBarController: UITabBarController
    var navigationController: UINavigationController
    var appBuilder: ApplicationBuilder
    var windows: UIWindow
    
    init(windows: UIWindow, tabBarController: UITabBarController, navigationController: UINavigationController, appBuilder: ApplicationBuilder) {
        self.windows = windows
        self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.appBuilder = appBuilder
    }
    
    func authNumberVC() {
        let vc = appBuilder.createAuthNumberModule(router: self)
        navigationController.setViewControllers([vc], animated: true)
        windows.rootViewController = navigationController
    }
    
    func authCodeVC() {
        let vc = appBuilder.createAuthCodeModule(router: self)
        windows.rootViewController?.navigationController?.show(vc, sender: nil)
    }

    func chatListVC() {

        let chatVC = appBuilder.createChatListModule(router: self)
        let chatNavVC = navigationController
        chatNavVC.tabBarItem.image = UIImage(systemName: "message")
        chatNavVC.tabBarItem.title = "Chats"
        chatNavVC.setViewControllers([chatVC], animated: true)
        
        let settingsVC = appBuilder.createSettingsModule(router: self)
        let settingsNavVC = navigationController
        settingsNavVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsNavVC.tabBarItem.title = "Settings"
        settingsNavVC.setViewControllers([settingsVC], animated: true)

        
        tabBarController.setViewControllers([chatNavVC], animated: true)
        windows.rootViewController = tabBarController
    }
    
    func popBack(){
        windows.rootViewController?.navigationController?.popToRootViewController(animated: true)
    }
}

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
    func start()
}

protocol RouterProtocol: RouterMain {
    func authCodeVC()
    func authNumberVC()
   // func contactVC()
    func chatListVC()
    func popBack()
    //func chatVC()
    //func settingVC()
}

class Router: RouterProtocol {
    
    var tabBarController: UITabBarController
    var appBuilder: ApplicationBuilder
    var windows: UIWindow
var navigationController: UINavigationController
    
    init(windows: UIWindow, tabBarController: UITabBarController, appBuilder: ApplicationBuilder, navigationController: UINavigationController) {
        self.windows = windows
        self.tabBarController = tabBarController
        self.appBuilder = appBuilder
        self.navigationController = navigationController
    }
    
    func start() {
//        let vc = appBuilder.createLoadingModule(router: self)
//        navigationController.setViewControllers([vc], animated: true)
//        windows.rootViewController = navigationController
        
        let vc = appBuilder.createAuthNumberModule(router: self)
       let nav = UINavigationController(rootViewController: vc)
        windows.rootViewController = nav
    }
    
    func authNumberVC() {
        let vc = appBuilder.createAuthNumberModule(router: self)
        navigationController.setViewControllers([vc], animated: true)

        
        windows.rootViewController = navigationController
        windows.makeKeyAndVisible()
    }
    
    func authCodeVC() {
        print ("authCodeVC")
        let vc = appBuilder.createAuthCodeModule(router: self)
        windows.rootViewController?.view.n
        
    }

    func chatListVC() {

        let chatVC = appBuilder.createChatListModule(router: self)
        let chatNavVC = UINavigationController(rootViewController: chatVC)
        chatNavVC.tabBarItem.image = UIImage(systemName: "message")
        chatNavVC.tabBarItem.title = "Chats"

        
        let settingsVC = appBuilder.createSettingsModule(router: self)
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        settingsNavVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingsNavVC.tabBarItem.title = "Settings"
    
        tabBarController.setViewControllers([chatNavVC,settingsNavVC], animated: true)
        windows.rootViewController = tabBarController
    }
    
    func popBack(){
        windows.rootViewController?.navigationController?.popToRootViewController(animated: true)
    }
}

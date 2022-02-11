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
        let vc = ChatViewControl()
        
        showNavigationVC(viewController: vc)
    }
    
    static func showAuth() {
        let vc = AuthViewController()
        sleep(1)
        showNavigationVC(viewController: vc)
    }
    
    static private func showNavigationVC(viewController vc: UIViewController) {
        let navigationVC = UINavigationController()
        
        navigationVC.navigationBar.titleTextAttributes  =  [.foregroundColor: UIColor.white ]
        navigationVC.viewControllers = [vc]
        
        window?.rootViewController = navigationVC
    }
}

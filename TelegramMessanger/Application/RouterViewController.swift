//
//  RootViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 16.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

protocol Router {
    var appBuilder: AssemblyModelBuilder{  get set }
    var current: UIViewController { get set }
}

protocol RouterProtocol: Router {
    func authCodeVC()
    func authNumberVC()
   // func contactVC()
    func chatListVC()
    func popBack()
    //func chatVC()
    //func settingVC()
    func start()
}

class RouterViewController: UIViewController, RouterProtocol  {
    
    private var tabBarControllerv : UITabBarController = {
        let vc = UITabBarController()
        vc.tabBar.barTintColor = .darkGray
        return vc
    }()
    var current = UIViewController()
    var appBuilder = AssemblyModelBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    func start() {
        current = appBuilder.createLoadingModule(router: self)
        
        addChild(current)
        //current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func authCodeVC() {
        let vc = appBuilder.createAuthCodeModule(router: self)
        current.show(vc, sender: nil)
    }
    
    func authNumberVC() {
        let vc = appBuilder.createAuthNumberModule(router: self)
        let navVC = UINavigationController(rootViewController: vc)
        
        addChild(navVC)
        //navVC.view.frame = view.bounds
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = navVC
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
    
        tabBarControllerv.setViewControllers([chatNavVC, settingsNavVC], animated: true)
  
        addChild(tabBarControllerv)
        tabBarControllerv.view.frame = view.bounds
        view.addSubview(tabBarControllerv.view)
        tabBarControllerv.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = tabBarControllerv
    }
    
    func popBack() {
        current.navigationController?.popToRootViewController(animated: true)
    }
}
    
//
//    func showMainScreen() {
//
//        let chatVC = chat()
//        chatVC.router = self
//        let chatNavVC = UINavigationController(rootViewController: chatVC)
//        chatNavVC.tabBarItem.image = UIImage(systemName: "message")
//        chatNavVC.tabBarItem.title = "Chats"
//
//
//        let settingsVC = chat()
//        settingsVC.router = self
//        settingsVC.view.backgroundColor = .blue
//        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
//        settingsNavVC.tabBarItem.image = UIImage(systemName: "gearshape")
//        settingsNavVC.tabBarItem.title = "Settings"
//        let  tabBarController = UITabBarController()
//
//        tabBarController.setViewControllers([chatNavVC,settingsNavVC], animated: true)
//
//        addChild(tabBarController)
//        tabBarController.view.frame = view.bounds
//        view.addSubview(tabBarController.view)
//        tabBarController.didMove(toParent: self)
//        current.willMove(toParent: nil)
//        current.view.removeFromSuperview()
//        current.removeFromParent()
//        current = tabBarController
//    }
//
//    func showMainAuth() {
//
//        let chatVC = auth()
//        chatVC.router = self
//        let chatNavVC = UINavigationController(rootViewController: chatVC)
//
//
//    }
//    func showMainCode() {
//        let chatVC = code()
//        chatVC.router = self
//        current.show(chatVC, sender: nil)
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */


//
//class loadingVC: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .red
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainScreen()
//    }
//}
//
//
//class chat: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .green
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainAuth()
//    }
//}
//
//class auth: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .yellow
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainCode()
//    }
//}
//
//class code: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .purple
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainScreen()
//    }
//}
//
//

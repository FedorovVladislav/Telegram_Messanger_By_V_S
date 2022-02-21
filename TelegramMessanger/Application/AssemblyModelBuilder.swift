//
//  ApplicationController.swift
//  tdlib-ios
//
//  Created by Anton Glezman on 28/09/2019.
//  Copyright © 2019 Anton Glezman. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createLoadingModule(router: RouterProtocol) -> UIViewController
    func createAuthNumberModule(router: RouterProtocol) -> UIViewController
    func createAuthCodeModule(router: RouterProtocol) -> UIViewController
    func createChatListModule(router: RouterProtocol) -> UIViewController
    func createChatModule(router: RouterProtocol, chatID: Int64, lastMess: Int64) -> UIViewController
    func createSettingsModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    func createChatModule(router: RouterProtocol, chatID: Int64, lastMess: Int64) -> UIViewController {
        let view = ChatViewController()
        let presenter = ChatPresenter(view: view, router: router, networkLayer: serviceManager.chatService, chatId: chatID, lastMess: lastMess)
        view.presenter = presenter
        return  view
    }
    
    
    private let serviceManager = ServiceManager()
    
    func createSettingsModule(router: RouterProtocol) -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view, router: router, networkManadger: serviceManager.authService)
        view.presenter = presenter
        return  view
    }
    
    func createLoadingModule(router: RouterProtocol) -> UIViewController {
        let view = LoadingViewController()
        view.router = router
        view.networkManager = serviceManager.authService
        return  view
    }
    
    func createAuthNumberModule(router: RouterProtocol) -> UIViewController {
        let view = AuthNumberViewController()
        let presenter = AuthNumberPresenter(view: view, router: router, networkLayer: serviceManager.authService )
        view.presenter = presenter
        return  view
    }
    
    func createAuthCodeModule(router: RouterProtocol) -> UIViewController {
        let view = AuthCodeViewController()
        let presenter = AuthCodePresenter(view: view, router: router, networkLayer: serviceManager.authService)
        view.presenter = presenter
        return  view
    }
   
    func createChatListModule(router: RouterProtocol) -> UIViewController {
        let view = ChatListViewController()
        let presenter = ChatListPresenter(view: view, router: router, networkLayer: serviceManager.chatListService)
        view.presenter = presenter
        return  view
    }
}

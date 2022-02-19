//
//  ChatPresenter.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 19.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation

protocol ChatViewProtocol {
    func showMessahe()
}

protocol ChatPresenterProtocol {
    init(view: ChatViewProtocol, router: RouterProtocol, networkLayer: ChatService, chatId: Int64)
    var view: ChatViewProtocol { get }
    var router: RouterProtocol  { get }
    var networkLayer: ChatService { get }
    
}

class ChatPresenter: ChatPresenterProtocol {
    let view: ChatViewProtocol
    let router: RouterProtocol
    let networkLayer: ChatService
    var chatId: Int64
 
    required init(view: ChatViewProtocol, router: RouterProtocol, networkLayer: ChatService, chatId: Int64) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
        self.chatId = chatId
        
        networkLayer.getChatMess(chatId: chatId)
    }
    
}


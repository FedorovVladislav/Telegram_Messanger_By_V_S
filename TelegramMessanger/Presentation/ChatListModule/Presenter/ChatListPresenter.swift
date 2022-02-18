//
//  ChatListPresenter.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 14.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit

protocol ChatListViewProtocol: class {
    func updateTableList(chatDic: [Int64 : ChatModel], chatPos: [ChatPositionlist])
    
}
protocol ChatListPresenterProtocol: class {
    init(view: ChatListViewProtocol, router: RouterProtocol, networkLayer: ChatListService)
    func openChat(chatID: Int64)
    func getContact()
}



class ChatListPresenter: ChatListPresenterProtocol {
    
    
    func getContact() {
        print("***ButtonWork***")
        networkLayer.getContact()
    }
    
    let view: ChatListViewProtocol
    let router: RouterProtocol
    let networkLayer: ChatListService
    
    required init(view: ChatListViewProtocol, router: RouterProtocol, networkLayer: ChatListService) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
        
        networkLayer.delegate = self
    }
    
    func openChat(chatID: Int64) {
        print(chatID)
    }
    
}
extension ChatListPresenter: ChatListDelegate {
    func updateChatList(chatDic: [Int64 : ChatModel], chatPos: [ChatPositionlist]) {
        view.updateTableList(chatDic: chatDic, chatPos: chatPos)
    }
    
    
}

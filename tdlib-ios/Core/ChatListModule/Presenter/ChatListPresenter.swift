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
    func updateTableList(chatData: [UpdateNewChat])
    
}
protocol ChatListPresenterProtocol: class {
    init(view: ChatListViewProtocol, router: RouterProtocol, networkLayer: ChatListService)
    func openChat(chatID: Int64)
}



class ChatListPresenter: ChatListPresenterProtocol {
    
    let view: ChatListViewProtocol
    let router: RouterProtocol
    let networkLayer: ChatListService
    
    required init(view: ChatListViewProtocol, router: RouterProtocol, networkLayer: ChatListService) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
        
        networkLayer.delegate = self
        
        let chatlist = ChatList.chatListMain
        print("*********************  GetContact  ***********************")
    
        try! networkLayer.api.loadChats(chatList: chatlist, limit: 29, completion: { result in
            
        })
    }
    
    func openChat(chatID: Int64) {
        print(chatID)
    }
}
extension ChatListPresenter: ChatListDelegate {
    func updateChatList(chatData: [UpdateNewChat]) {
        
        print("Delegate work")
        view.updateTableList(chatData: chatData)
    }
}

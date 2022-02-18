//
//  ServiceManager.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation

class ServiceManager {

    let telegramService: TelegramService
    let authService: AuthService
    let chatListService: ChatListService
    let chatService: ChatService

    init() {
        telegramService = TelegramService()
        
        authService = AuthService(tdApi: telegramService.api)
        telegramService.add(listener: authService)
        
        chatListService = ChatListService(tdApi: telegramService.api)
        telegramService.add(listener: chatListService)
        
        chatService = ChatService(tdApi: telegramService.api)
        telegramService.add(listener: chatService)
    }
}


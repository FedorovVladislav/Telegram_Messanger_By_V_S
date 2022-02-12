//
//  ServiceManager.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation

class ServiceManager {
    
    static let shared = ServiceManager()

    let telegramService: TelegramService
    let authService: AuthService
    let chatListService: ChatListService
    let chatService: ChatService

    private init () {
        
        telegramService = TelegramService()
        
        authService = AuthService(tdApi: telegramService.api)
        telegramService.add(listener: authService)
        
        chatListService = ChatListService()
        telegramService.add(listener: chatListService)
        
        chatService = ChatService()
        telegramService.add(listener: chatService)
    }
}


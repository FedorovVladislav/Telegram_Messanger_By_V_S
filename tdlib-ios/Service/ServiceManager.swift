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
   // let chatListService: ChatListService
    private init () {
        
        self.telegramService = TelegramService()
        self.authService = AuthService(tdApi: telegramService.api)
        telegramService.authDatadelegate = authService
        
        
        
        
    }
}

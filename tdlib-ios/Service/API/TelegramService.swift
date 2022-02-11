//
//  TelegramService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit
//import UIKit

protocol AuthDataDelegate {
    func updateAuthData(update: UpdateAuthorizationState)
}

class TelegramService {
        
    let api: TdApi
    var authDatadelegate: AuthDataDelegate?
    
    init(){
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = TdApi(client: client)
    }
    
    func run() {
        
        api.client.run(updateHandler: { [self] data in
            
            do {
                let update = try self.api.decoder.decode(Update.self, from: data)
                print("NewMessage ")
             
                if case .updateAuthorizationState(let state) = update {
                    authDatadelegate?.updateAuthData(update: state)
                }
                if case .updateNewMessage(let state) = update {
                    print ("updateNewMessage")
                }
        
            } catch {
                print("error decode")
            }
        })
    }
    
}

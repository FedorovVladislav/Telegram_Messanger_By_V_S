//
//  TelegramService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit
import UIKit

protocol ApiDataDelegate {
    
  func updateData(update: Update)
}

class TelegramService {
    
    let logger = StdOutLogger()
    
    let api: TdApi
    
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
                    
                    switch state.authorizationState {
                        
                    case .authorizationStateWaitTdlibParameters:
                        
                        print ("Set authorizationStateWaitTdlibParameters")
                        
                        guard let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                            return
                        }
                        let tdlibPath = cachesUrl.appendingPathComponent("tdlib", isDirectory: true).path
                        let params = TdlibParameters(
                            apiHash: apiHash, // https://core.telegram.org/api/obtaining_api_id
                            apiId: apiId,
                            applicationVersion: "1.0",
                            databaseDirectory: tdlibPath,
                            deviceModel: "iOS",
                            enableStorageOptimizer: true,
                            filesDirectory: "",
                            ignoreFileNames: true,
                            systemLanguageCode: "en",
                            systemVersion: "Unknown",
                            useChatInfoDatabase: true,
                            useFileDatabase: true,
                            useMessageDatabase: true,
                            useSecretChats: true,
                            useTestDc: false)
                        try self.api.setTdlibParameters(parameters: params) { [weak self] in
                            print("result \($0)")
                            //self?.chekResult($0)
                        }
                        break
                    case .authorizationStateWaitEncryptionKey(_):
                        let keyData = "sdfsdkjfkbsddsj".data(using: .utf8)!
                                    try api.checkDatabaseEncryptionKey(encryptionKey: keyData) { [weak self] in
                                        //self?.chekResult($0)
                                        print("result \($0)")
                                    }
                        break
                        
                    case .authorizationStateWaitPhoneNumber:
                        print("authorizationStateWaitPhoneNumber")
                        break
                    case .authorizationStateWaitCode(_):
                        break
                    case .authorizationStateWaitOtherDeviceConfirmation(_):
                        break
                    case .authorizationStateWaitRegistration(_):
                        break
                    case .authorizationStateWaitPassword(_):
                        break
                    case .authorizationStateReady:
                        print("authorizationStateReady")
                        break
                    case .authorizationStateLoggingOut:
                        break
                    case .authorizationStateClosing:
                        break
                    case .authorizationStateClosed:
                        break
                    }
                    
                    }
        
            } catch {
                print("error decode")
            }
        })
    }
    
    func authphone(){
        
         let phoneNumberAuthenticationSettings = PhoneNumberAuthenticationSettings(allowFlashCall: false, allowMissedCall: false, allowSmsRetrieverApi: false, authenticationTokens: [], isCurrentPhoneNumber: true)
         
             do {
                 try api.setAuthenticationPhoneNumber(phoneNumber: "79581760204", settings: phoneNumberAuthenticationSettings, completion: { result in
                     print (" resuil ti closer : \(result.publisher.result)")
                 })
             } catch {
                 print("Error  write")
             }
    }
    func setCode(code: String)
    {
        do{
           try  api.checkAuthenticationCode(code: code, completion: { result in
            
            print (" resuil ti closer : \(result.publisher.result)")
            
        })
        } catch {
            print("Error  code registr")
        }
}
}

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
                    if case .authorizationStateWaitTdlibParameters = state.authorizationState {
                        
                        print ("Set authorizationStateWaitTdlibParameters")
                        
                        guard let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                            return
                        }
                        let tdlibPath = cachesUrl.appendingPathComponent("tdlib", isDirectory: true).path
                        let params = TdlibParameters(
                            apiHash: "6d72a8a01c126ebb38035f39a9083542", // https://core.telegram.org/api/obtaining_api_id
                            apiId: 287311,
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
                    }

                }
            } catch {
                print("error")
            }
        })
    }
}

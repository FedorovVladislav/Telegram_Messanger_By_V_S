//
//  AuthService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//
import TdlibKit
import UIKit

protocol NetworkServiceProtocol {
    func updateData(update: Update)
}
protocol authStateDelegate {
    func authStare(state: Bool)
}

class AuthService {
    
    // MARK: - Private properties
    
    private let api: TdApi
    private var authorizationState: AuthorizationState?
    var authDelegate: authStateDelegate?
    
    // MARK: - Public properties
   
    
    // MARK: - Init
    
    init(tdApi: TdApi) {
        self.api = tdApi
    }
    
    func authphone(phoneNumber: String) {
        let phoneNumberAuthenticationSettings = PhoneNumberAuthenticationSettings(allowFlashCall: false,
                                                                                  allowMissedCall: false,
                                                                                  allowSmsRetrieverApi: false,
                                                                                  authenticationTokens: [],
                                                                                  isCurrentPhoneNumber: true
        )
        
        try! api.setAuthenticationPhoneNumber(phoneNumber: phoneNumber, settings: phoneNumberAuthenticationSettings, completion: { result in })
    }
    
    func sendAuthCode(code: String) {
        try! api.checkAuthenticationCode(code: code, completion: { result in })
    }
    
    func loggOff() {
            try! api.logOut(completion: { result in })
        }
    
    private func authorizationStateWaitTdlibParameters() {
        do {
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
                systemLanguageCode: "ru",
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
        } catch {
            print ("error in del func ")
        }
    }
    
    private func authorizationStateWaitEncryptionKey() {
        let keyData = "sdfsdkjfkbsddsj".data(using: .utf8)!
        
        try! api.checkDatabaseEncryptionKey(encryptionKey: keyData) { _ in }
    }
    
    private func updateState(data: UpdateAuthorizationState) {
        
        switch data.authorizationState {
   
        case .authorizationStateWaitTdlibParameters:
            authorizationStateWaitTdlibParameters()

        case .authorizationStateWaitEncryptionKey(_):
            authorizationStateWaitEncryptionKey()

        case .authorizationStateWaitPhoneNumber:
            self.authDelegate?.authStare(state: false)
   
        case .authorizationStateWaitCode(_):
            break
   
        case .authorizationStateWaitOtherDeviceConfirmation(_):
            break
   
        case .authorizationStateWaitRegistration(_):
            break
   
        case .authorizationStateWaitPassword(_):
            break
   
        case .authorizationStateReady:
            self.authDelegate?.authStare(state: true)
   
        case .authorizationStateLoggingOut:
            self.authDelegate?.authStare(state: false)
   
        case .authorizationStateClosing:
            break
   
        case .authorizationStateClosed:
            self.authDelegate?.authStare(state: false)
        }
    }
}

extension AuthService: UpdateListeners {
    func updateData(update: Update) {
        if case .updateAuthorizationState(let state) = update {
            self.updateState(data: state)
            print("AuthService")
        }
    }
}

//
//  AuthService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit

class AuthService {
    
    // MARK: - Private properties
    
    private let api: TdApi
   private var authorizationState: AuthorizationState?
    
    
    // MARK: - Public properties
    
    private(set) var isAuthorized: Bool = false
   // weak var delegate: AuthServiceDelegate?
    
    
    // MARK: - Init
    
    init(tdApi: TdApi) {
        self.api = tdApi
    }
    
}

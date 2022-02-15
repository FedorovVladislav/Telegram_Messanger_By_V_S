//
//  AuthCodePresenter.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 14.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation

protocol AuthCodeViewProtocol: class {
    
}

protocol AuthCodePresenterProtocol: class {
    init (view: AuthCodeViewProtocol, router: RouterProtocol,networkLayer: AuthService)
    func getCode(code: String)
}

class  AuthCodePresenter: AuthCodePresenterProtocol {
    
    
    var view: AuthCodeViewProtocol
    var router: RouterProtocol
    let networkLayer: AuthService
    
    required init(view: AuthCodeViewProtocol, router: RouterProtocol, networkLayer: AuthService) {
        self.router = router
        self.view = view
        self.networkLayer  = networkLayer
    }
    
    func getCode(code: String) {
        networkLayer.sendAuthCode(code: code)
    }
}

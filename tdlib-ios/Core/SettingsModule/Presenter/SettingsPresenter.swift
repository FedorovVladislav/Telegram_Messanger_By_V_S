//
//  SettingsPresenter.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 15.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation

protocol SettingsViewProtocol{

}

protocol SettingsPresenterProtocol{
    init(view: SettingsViewProtocol, router: RouterProtocol, networkManadger: AuthService)
    func signOut()
}

class SettingsPresenter: SettingsPresenterProtocol {
    let view: SettingsViewProtocol
    let router: RouterProtocol
    let nerworkManager: AuthService
    
    required init(view: SettingsViewProtocol, router: RouterProtocol, networkManadger: AuthService) {
        self.view = view
        self.router = router
        self.nerworkManager = networkManadger
    }
    
    func signOut() {
        nerworkManager.loggOff()
    }
}


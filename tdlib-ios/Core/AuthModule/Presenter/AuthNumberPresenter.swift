import Foundation

protocol AuthNumberViewProtocol: class {
    
}

protocol AuthNumberPresenterProtocol: class {
    init(view: AuthNumberViewProtocol, router: RouterProtocol,networkLayer: AuthService)
    func sendCode(number: String)
}

class AuthNumberPresenter: AuthNumberPresenterProtocol {
    let view: AuthNumberViewProtocol
    let router: RouterProtocol
    let networkLayer: AuthService
    
    required init(view: AuthNumberViewProtocol, router: RouterProtocol,networkLayer: AuthService) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
    }
    
    func sendCode(number: String) {
        networkLayer.authphone(phoneNumber: number)
        router.authCodeVC()
    }
}

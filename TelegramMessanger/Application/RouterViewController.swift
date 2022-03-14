import UIKit
import TdlibKit

protocol Router {
    var appBuilder: AssemblyModelBuilder{  get set }
    var current: UIViewController { get set }
}

protocol RouterProtocol: Router {
    func authCodeVC()
    func authNumberVC()
    //func contactVC()
    func chatListVC()
    func popBack()
    func chatVC(chat: ChatModel)
    func contentView(conetnt: UIImage)
    //func settingVC()
    func start()
}

class RouterViewController: UIViewController, RouterProtocol {
    
    var current = UIViewController()
    var appBuilder = AssemblyModelBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    func start() {
        current = appBuilder.createLoadingModule(router: self)
        addChild(current)
        //current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func authCodeVC() {
        let vc = appBuilder.createAuthCodeModule(router: self)
        current.show(vc, sender: nil)
    }
    
    func chatVC(chat: ChatModel) {
        let vc = appBuilder.createChatModule(router: self, chat: chat)
        
        for nv in self.current.children {
            if nv.nibName == "Chats" {
                nv.show(vc, sender: nil)
            }
        }
    }
    
    func contentView(conetnt: UIImage) {
        let vc = appBuilder.createContentView(router: self, content: conetnt)
        for nv in self.current.children {
            print ("**** Find Navig VC ****")
            if nv.nibName == "Chats" {
                nv.show(vc, sender: nil)
            }
        }
    }
    
    func authNumberVC() {
        let vc = appBuilder.createAuthNumberModule(router: self)
        let navVC = createNavigaionVC(vc: vc, nibName: nil, tabBarImage: nil, tabBarTitle: nil)
        changeCurrentVC(vc: navVC)
    }
    
    func chatListVC() {
        let contactVC       = createNavigaionVC(vc: UIViewController(),
                                                nibName: "Contacts",
                                                tabBarImage: UIImage(systemName: "person.crop.circle.fill"),
                                                tabBarTitle: "Contacts")
        
        let chatNavVC       = createNavigaionVC(vc: appBuilder.createChatListModule(router: self),
                                                nibName: "Chats",
                                                tabBarImage: UIImage(systemName: "message"),
                                                tabBarTitle: "Chats")
    
        let settingsNavVC   = createNavigaionVC(vc: appBuilder.createSettingsModule(router: self),
                                                nibName: "Settings",
                                                tabBarImage: UIImage(systemName: "gearshape"),
                                                tabBarTitle:  "Settings")
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.barStyle = .black
        tabBarVC.setViewControllers([contactVC, chatNavVC, settingsNavVC], animated: true)
        changeCurrentVC(vc: tabBarVC)
    }
    
    func popBack() {
        current.navigationController?.popToRootViewController(animated: true)
    }
    
    private func changeCurrentVC(vc newVC: UIViewController) {
        addChild(newVC)
        //tabbar.view.frame = view.bounds
        view.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = newVC
    }
    
    private func createNavigaionVC(vc newVC: UIViewController,nibName: String?, tabBarImage: UIImage?, tabBarTitle: String?) -> UINavigationController {
       
        let navVC = UINavigationController(nibName: nibName, bundle: nil)
        navVC.setViewControllers([newVC], animated: true)
        navVC.modalPresentationStyle = .fullScreen
        navVC.navigationBar.barStyle = .black
        
        
        if let tabBarImage = tabBarImage {
            navVC.tabBarItem.image = tabBarImage
        }
        
        if let tabBarTitle = tabBarTitle {
            navVC.tabBarItem.title = tabBarTitle
        }
        
        return navVC
    }
}
    
//
//    func showMainScreen() {
//
//        let chatVC = chat()
//        chatVC.router = self
//        let chatNavVC = UINavigationController(rootViewController: chatVC)
//        chatNavVC.tabBarItem.image = UIImage(systemName: "message")
//        chatNavVC.tabBarItem.title = "Chats"
//
//
//        let settingsVC = chat()
//        settingsVC.router = self
//        settingsVC.view.backgroundColor = .blue
//        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
//        settingsNavVC.tabBarItem.image = UIImage(systemName: "gearshape")
//        settingsNavVC.tabBarItem.title = "Settings"
//        let  tabBarController = UITabBarController()
//
//        tabBarController.setViewControllers([chatNavVC,settingsNavVC], animated: true)
//
//        addChild(tabBarController)
//        tabBarController.view.frame = view.bounds
//        view.addSubview(tabBarController.view)
//        tabBarController.didMove(toParent: self)
//        current.willMove(toParent: nil)
//        current.view.removeFromSuperview()
//        current.removeFromParent()
//        current = tabBarController
//    }
//
//    func showMainAuth() {
//
//        let chatVC = auth()
//        chatVC.router = self
//        let chatNavVC = UINavigationController(rootViewController: chatVC)
//
//
//    }
//    func showMainCode() {
//        let chatVC = code()
//        chatVC.router = self
//        current.show(chatVC, sender: nil)
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */


//
//class loadingVC: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .red
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainScreen()
//    }
//}
//
//
//class chat: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .green
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainAuth()
//    }
//}
//
//class auth: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .yellow
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainCode()
//    }
//}
//
//class code: UIViewController {
//
//    var router : RouterViewController?
//
//    let signInButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign In", for: .normal)
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        button.backgroundColor = .darkGray
//
//        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
//
//        return button
//    }()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        view.backgroundColor = .purple
//        view.addSubview(signInButton)
//
//        NSLayoutConstraint.activate([
//            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            signInButton.heightAnchor.constraint(equalToConstant: 50),
//            signInButton.widthAnchor.constraint(equalToConstant: 50)
//        ])
//
//    }
//    @objc private func signIn() {
//        router?.showMainScreen()
//    }
//}
//
//

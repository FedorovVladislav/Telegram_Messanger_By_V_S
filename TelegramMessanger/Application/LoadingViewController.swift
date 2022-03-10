//
//  LoadingViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    //MARK: - UIElement
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let iconImage = UIImage(named: "Telegram_Messenger")
        imageView.image = iconImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activitiIndicator
    }()
    
    //MARK: - Data
    var networkManager: AuthService? = nil
    var router: RouterProtocol? = nil
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()

        networkManager?.authDelegate  = self
        self.view.backgroundColor = .black
        
        view.addSubview(iconImageView)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    //MARK: - Setup Interface
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -120),
            iconImageView.heightAnchor.constraint(equalToConstant: 130),
            iconImageView.widthAnchor.constraint(equalToConstant: 130),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 150)
        ])
    }
}

//MARK: - authStateDelegate
extension  LoadingViewController: AuthStateDelegate {
    
    func authState(state: Bool) {
        if state {
            router?.chatListVC()
        } else {
            router?.authNumberVC()
        }
    }
}

//
//  ChatViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class ChatViewControl: UIViewController {
    
    let logOffButton: UIButton = {
       
        let button = UIButton()
        button.addTarget(self, action: #selector(logOff), for: .touchUpInside)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.setTitle("Sign out", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chat VC load")
        
        view.addSubview(logOffButton)
        
        NSLayoutConstraint.activate([
        
            logOffButton.heightAnchor.constraint(equalToConstant: 50),
            logOffButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:  30),
            logOffButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logOffButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc func logOff() {
        ServiceManager.shared.authService.loggOff()
    }
}

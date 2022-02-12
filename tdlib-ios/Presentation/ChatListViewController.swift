//
//  ChatViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import TdlibKit

class ChatListViewController: UIViewController {
//
//    let chatListButton: UIButton = {
//        let button = UIButton()
//
//        button.addTarget(self, action: #selector(getChatList), for: .touchUpInside)
//        button.tintColor = .white
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = tru
//        button.backgroundColor = .systemBlue
//        button.setTitle("getChatList", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat List"
        
       // view.addSubview(chatListButton)
        
//        NSLayoutConstraint.activate([
//            chatListButton.heightAnchor.constraint(equalToConstant: 50),
//            chatListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:  30),
//            chatListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            chatListButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 80)
//        ])
    }
    
    @objc func getChatList() {
        let chatlist = ChatList.chatListMain
        print("*********************  GetContact  ***********************")
        try! ServiceManager.shared.telegramService.api.loadChats(chatList: chatlist, limit: 20, completion: { result in

        })
    }
}

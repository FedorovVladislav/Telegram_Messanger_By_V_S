//
//  File.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    var chatId: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(chatId)"
        updateMess()
    }
    
    func updateMess(){
        print("*** OpenChat ***")
//        try! ServiceManager.shared.telegramService.api.getChat(chatId: chatId, completion: {res  in
//        })
    }
    
}

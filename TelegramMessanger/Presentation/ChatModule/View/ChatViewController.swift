//
//  File.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    var presenter: ChatPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
    }
}
extension ChatViewController: ChatViewProtocol {
    func showMessahe() {
        
    }
}

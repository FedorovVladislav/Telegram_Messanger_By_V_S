//
//  File.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import TdlibKit

class ChatViewController: UIViewController {
    
    var mess : [Message]?
    
    var presenter: ChatPresenterProtocol!
    
    let chatTable: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.rowHeight =  60
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  .white
        
        view.addSubview(chatTable)
        chatTable.dataSource = self
        
        NSLayoutConstraint.activate([
            chatTable.topAnchor.constraint(equalTo: view.topAnchor),
            chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mess?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell" )
        guard let message =  mess?[indexPath.row] else {
            cell.textLabel?.text = "Lol"
            return cell
        }
        switch message.content {
            case .messageText(let messageText):
                cell.textLabel?.text = messageText.text.text
            default:
                cell.textLabel?.text = "Content "
        }
        return cell
    }
    
    
}

extension ChatViewController: ChatViewProtocol {
    func showMessahe(data: [Message]) {
        self.mess = data
        chatTable.reloadData()  
    }
    
   
}

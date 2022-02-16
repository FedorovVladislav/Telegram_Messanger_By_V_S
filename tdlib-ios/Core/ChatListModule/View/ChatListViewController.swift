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
    
    let chatTable: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        
        return tableView
    }()
    let reloadButton :UIBarButtonItem = {
        let image = UIImage(systemName: "repeat")
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(updateTable))
        
        
        return barButtonItem
    }()
   
    var presenter: ChatListPresenter!
    
    var chatData: [UpdateNewChat]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat List"
        
        navigationItem.rightBarButtonItem = reloadButton
        
        view.addSubview(chatTable)
        chatTable.dataSource = self
        chatTable.delegate = self
        
        NSLayoutConstraint.activate([
            chatTable.topAnchor.constraint(equalTo: view.topAnchor),
            chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getContact()
    }
    
    func getChatList() {
        
    }
    
    @objc func updateTable() {
        presenter.getContact()
    }
}
extension ChatListViewController: ChatListViewProtocol {
    
    func updateTableList(chatData: [UpdateNewChat]) {
        self.chatData = chatData
        updateTable()
    }

}

extension ChatListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default,reuseIdentifier: "Cell")
        cell.textLabel?.text = chatData?[indexPath.row].chat.title ?? "nil"
        cell.textLabel?.textColor = .systemGray
        cell.backgroundColor = .black
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc = ChatViewController()
        //vc.chatId = ServiceManager.shared.chatListService.chatList[indexPath.row].chat.id
        self.show(vc, sender: nil)
    }
}

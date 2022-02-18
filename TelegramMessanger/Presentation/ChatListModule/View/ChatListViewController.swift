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
    
    init(){
        super.init(nibName: nil, bundle: nil)
        print("************* ChatListViewController init *************")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let chatTable: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.rowHeight =  60
        
        
        return tableView
    }()
    let reloadButton: UIBarButtonItem = {
        let image = UIImage(systemName: "repeat")
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(getDat))
        
        return barButtonItem
    }()
   
    var presenter: ChatListPresenter!
    
    var chatData: [UpdateNewChat]?
    
    var chatDic: [Int64 : ChatModel]?
        
    var chatPos: [ChatPositionlist]?
    
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
        presenter.networkLayer.getContact()
    }
    
    func getChatList() {
        
    }
    
    @objc func getDat() {
        print("BBarButtonWork")
        presenter.getContact()
    }
}
extension ChatListViewController: ChatListViewProtocol {
    func updateTableList(chatDic: [Int64 : ChatModel], chatPos: [ChatPositionlist]) {
        self.chatPos = chatPos
        self.chatDic = chatDic
        chatTable.reloadData()
    }
}

extension ChatListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return chatPos?.count ?? 10

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath)  as! ChatTableViewCell
        guard let  chatPos  = chatPos, let  chatDic = chatDic else {
            cell.name.text = "nil"
            return cell
        }
        if  indexPath.row + 1 < chatPos.count {
        let charmodel = chatDic[chatPos[indexPath.row].chatId]
        cell.name.text = charmodel?.title
        }
            return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc = ChatViewController()
        //vc.chatId = ServiceManager.shared.chatListService.chatList[indexPath.row].chat.id
        self.show(vc, sender: nil)
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}





//
//  File.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import MessageKit
import TdlibKit
import InputBarAccessoryView

struct messagee: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: MessageKit.Date
    var kind: MessageKind
    
    init(text: String, userId: Int64){
        sender = sendertype(senderId: userId)
        messageId = "messageID"
        sentDate = MessageKit.Date(timeIntervalSinceNow: 1)
        kind = .text(text)
    }
}

struct sendertype: SenderType {
    var senderId: String
    var displayName: String

    
    init (senderId: Int64){
        self.senderId = "\(senderId)"
        displayName = "hol"
    }
}

class ChatViewController: MessagesViewController {
    
    
    
    var presenter: ChatPresenterProtocol!
    var senderId: String = "\(883411616)"
    private var messages: [messagee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeMessageAvatars()
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.backgroundColor = .black
    
        title = "Chat"
    }
    private func removeMessageAvatars() {
      guard
        let layout = messagesCollectionView.collectionViewLayout
          as? MessagesCollectionViewFlowLayout
      else {
        return
      }
      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
      layout.setMessageIncomingAvatarSize(.zero)
      layout.setMessageOutgoingAvatarSize(.zero)
      let incomingLabelAlignment = LabelAlignment(
        textAlignment: .left,
        textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
      layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
      let outgoingLabelAlignment = LabelAlignment(
        textAlignment: .right,
        textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
      layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return sendertype(senderId: 883411616)
    }
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == self.senderId ? true : false
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?  .systemBlue : .darkGray
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
      }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print( "***** didPressSendButtonWith ****")
        inputBar.inputTextView.text = ""
        presenter.networkLayer.sendMess(text: text)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        print( "***** didChangeIntrinsicContentTo ****")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        print( "***** textViewTextDidChangeTo ****")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        print( "***** didSwipeTextViewWith ****")
    }
}

extension ChatViewController: ChatViewProtocol {
    func showMessahe(data: [Message]) {
        var res: [messagee] = []
        for mes in data{
            var  senderId: Int64 = 0
            switch mes.senderId {
                
            case .messageSenderUser(let sender):
                senderId = sender.userId
            case .messageSenderChat(_):
                break
            }
            
            switch mes.content {
            case .messageText(let  textMes):
                
                res.append(messagee(text: textMes.text.text, userId: senderId))
            default:
                res.append(messagee(text: "Content", userId: senderId))
            }
        }
        self.messages =  res
        
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }
}



//
//    var mess : [Message]?
//
//    var presenter: ChatPresenterProtocol!
//
//    let chatTable: UITableView = {
//        let tableView = UITableView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .black
//        tableView.rowHeight =  60
//
//        return tableView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor =  .white
//
//        view.addSubview(chatTable)
//        chatTable.dataSource = self
//
//        NSLayoutConstraint.activate([
//            chatTable.topAnchor.constraint(equalTo: view.topAnchor),
//            chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
//
//extension ChatViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mess?.count ?? 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell" )
//        guard let message =  mess?[indexPath.row] else {
//            cell.textLabel?.text = "Lol"
//            return cell
//        }
//        switch message.content {
//            case .messageText(let messageText):
//                cell.textLabel?.text = messageText.text.text
//            default:
//                cell.textLabel?.text = "Content "
//        }
//        return cell
//    }
//
//
//}
//
//extension ChatViewController: ChatViewProtocol {
//    func showMessahe(data: [Message]) {
//        self.mess = data
//        chatTable.reloadData()
//    }
//
//
//}

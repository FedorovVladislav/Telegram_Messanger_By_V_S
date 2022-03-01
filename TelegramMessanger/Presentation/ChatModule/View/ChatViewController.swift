//
//  File.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        
        return control
    }()
    var presenter: ChatPresenterProtocol!
    var senderId: Int64?
    var chatTitle: String = "" {
        didSet {
            title = chatTitle
        }
    }
  
    private var messages: [MessageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = presenter.networkLayer.getSenderID()

        setupMessagesCollectionView()
        setupMessageInputBar()
    }
    
    private func removeMessageAvatars() {
        guard let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else { return }
        
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        layout.setMessageIncomingAvatarSize(.zero)
        layout.setMessageOutgoingAvatarSize(.zero)
        
        let incomingLabelAlignment = LabelAlignment(textAlignment: .left,
                                                    textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
      
        let outgoingLabelAlignment = LabelAlignment(textAlignment: .right,
                                                    textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
        layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
    
    private func setupMessagesCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messagesCollectionView.backgroundColor = .black
        messagesCollectionView.refreshControl = refreshControl
        
        removeMessageAvatars()
    }

    private func setupMessageInputBar() {
        messageInputBar.delegate = self
        
        messageInputBar.inputTextView.tintColor = .white
        messageInputBar.inputTextView.textColor = .white
        messageInputBar.backgroundView.backgroundColor = .black
    }
    
    @objc private func loadMoreMessages(){
         print ("***** LoadMore Message *******")
     }
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return SenderTypeModel(senderId: senderId ?? 0)
    }
    func isFromCurrentSender(message: MessageType) -> Bool {
        guard let senderId = senderId else { return false }
        return message.sender.senderId == "\(senderId)" ? true : false
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
        presenter.sendMessage(text: text)
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
   
    func showMessahe(data: [MessageModel]) {
        self.messages = data
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }
}

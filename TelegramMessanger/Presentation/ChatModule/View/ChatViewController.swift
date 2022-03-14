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
    
    //MARK: - UIElement
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
      
        return control
    }()
    private let profileImageBarItem: UIBarButtonItem = {
        let barButtonImage = UIBarButtonItem(image: UIImage(systemName: "paperplane.circle.fill"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(openProfile))
        
        return barButtonImage
    }()
    
    //MARK: - Data
    var presenter: ChatPresenterProtocol!
    var senderId: Int64?
    var chatTitle: String = "" {
        didSet {
            title = chatTitle
        }
    }
    var chatImagePath: String = "" {
        didSet {
           setUpProfileButton(imagePath: chatImagePath)
        }
    }
    private var messages: [MessageModel] = []
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = presenter.networkLayer.getSenderID()
        setupMessagesCollectionView()
        setupMessageInputBar()
    }
    
    //MARK: - SetupUI
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
        messagesCollectionView.messageCellDelegate = self
        
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
    
    private func setUpProfileButton(imagePath: String) {
        guard let profileImage = UIImage(contentsOfFile: imagePath) else { return }
        
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0.0, y: 0.0, width: 38, height: 30)
        profileButton.setImage(profileImage, for: .normal)
        profileButton.addTarget(self, action: #selector(openProfile), for: UIControl.Event.touchUpInside)
        profileButton.layer.cornerRadius = profileButton.frame.width/2
        profileButton.clipsToBounds = true

        let profileBarItem = UIBarButtonItem(customView: profileButton)
        NSLayoutConstraint.activate([
            profileBarItem.customView!.widthAnchor.constraint(equalToConstant: 40),
            profileBarItem.customView!.heightAnchor.constraint(equalToConstant: 40)
        ])

        navigationItem.rightBarButtonItem = profileBarItem
    }
    
    //MARK: - Button Action
    @objc private func openProfile() {
        print ("***** Open Profile *******")
     }
    @objc private func loadMoreMessages() {
        presenter.loadMoreMessage()
     }
}

    //MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return SenderTypeModel(senderId: senderId ?? 0)
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        guard let senderId = senderId else { return false }
        return message.sender.senderId == "\(senderId)" ? true : false
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return  messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

    //MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

    //MARK: - MessagesDisplayDelegate
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

    //MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
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

    //MARK: - ChatViewProtocol
extension ChatViewController: ChatViewProtocol {
    func showMessahe(data: [MessageModel]) {
        let indexScrolTo = data.count - self.messages.count
        
        self.messages = data
        messagesCollectionView.reloadData()
        if refreshControl.isRefreshing {
            messagesCollectionView.scrollToItem(at: IndexPath(row: 0, section: 20), at: .top, animated: false)
        } else {
            messagesCollectionView.scrollToLastItem()
        }
        refreshControl.endRefreshing()
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
    }
    func didTapImage(in cell: MessageCollectionViewCell) {

        print("******** didTapImage ******** ")
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        if case .photo(let content) =  messages[indexPath.section].kind {
            guard let image = content.image else { return }
            presenter.viewConetnt(message: image)
        }
    }
}
 


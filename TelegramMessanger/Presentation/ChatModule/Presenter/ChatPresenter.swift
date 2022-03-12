import Foundation
import TdlibKit
import CoreMIDI
import MessageKit
import UIKit

protocol ChatViewProtocol: AnyObject {
    func showMessahe(data: [MessageModel])
    var chatTitle: String { get set }
    var chatImagePath: String {  get  set }
}

protocol ChatPresenterProtocol: AnyObject {
    init(view: ChatViewProtocol, router: RouterProtocol, networkLayer: ChatService, chat: ChatModel)
    var router: RouterProtocol  { get }
    var networkLayer: ChatService { get }
    func sendMessage(text: String)
    func loadMoreMessage()
}

class ChatPresenter: ChatPresenterProtocol {
 
    //MARK: - Data
    weak var view: ChatViewProtocol?
    let router: RouterProtocol
    let networkLayer: ChatService
    var chatId: Int64
    var messages = [Int64: MessageModel]()
    let loadingFileManager: LoadingFileManager
    
    //MARK: - Init
    required init(view: ChatViewProtocol, router: RouterProtocol, networkLayer: ChatService, chat: ChatModel) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
        self.chatId = chat.chatId
        self.loadingFileManager = LoadingFileManager(networkLayer: networkLayer)
        
        if let message = chat.lastMessage {
            updateMessageForView(message: message)
            view.showMessahe(data: prepairDataForModel())
        }
        
        if let title = chat.title {
            self.view?.chatTitle =  title
        }
        
        if let profileImagePath = chat.photoInfoPath {
            self.view?.chatImagePath  =  profileImagePath
        }
        
        loadingFileManager.delegate = self
        networkLayer.delegate = self
        networkLayer.getChatMess(chatId: chatId, lastMess: chat.lastMessage?.id)
    }
    
    //MARK: - ChatPresenterProtocol
    func sendMessage(text: String) {
        networkLayer.sendMess(chatId: chatId, text: text)
    }
    
    func loadMoreMessage() {
        var lastId: Int64 = messages.first?.key ?? 0
        for message in messages {
            if message.key < lastId {
                lastId = message.key
            }
        }
        networkLayer.getChatMess(chatId: chatId, lastMess: lastId)
    }
    
    //MARK: - Work with data
    private func prepairDataForModel() -> [MessageModel] {
        var result: [MessageModel] = []
        
        for (_, message) in messages {
            result.append(message)
        }
        result.sort { $0.id < $1.id }
        return result
    }
    
    private func updateMessagesData( messageID: Int64, text: MessageKind, userId: Int64?) {
        if messages[messageID] == nil {
            messages[messageID] = MessageModel(id: messageID, text: text, userId: userId ?? 0)
        } else {
            messages[messageID]!.kind = text
        }
    }
    
    func updateMessageForView(message: Message) {
        
        var messageContent = MessageKind.text("Content")
        
        if case .messageText(let content) = message.content {
            messageContent = MessageKind.text(content.text.text)
        }
        
        if case .messagePhoto(let content) = message.content {
            if let photo = content.photo.sizes.first {
                if photo.photo.local.isDownloadingCompleted {
                    if let image = UIImage(contentsOfFile: photo.photo.local.path) {
                        messageContent = .photo(PhotoMedia(image: image, size: image.size))
                    }
                } else {
                    messageContent = MessageKind.photo(PhotoMedia())
                    loadingFileManager.startLoading(uniqId:  message.id, file: photo.photo)
                }
            }
        }
        
        var  senderId: Int64 = 0
        if case .messageSenderUser(let sender) = message.senderId {
            senderId = sender.userId
        }
        updateMessagesData(messageID: message.id, text: messageContent, userId: senderId)
    }
}

    //MARK: - ChatServiceDelegate
extension ChatPresenter: ChatServiceDelegate {
    
    func updateData(update: Update) {
        switch update {
            
        case .updateChatLastMessage(let updateChatLastMessage):
            print("******** updateChatLastMessage *******")
            guard let message = updateChatLastMessage.lastMessage else { return }
            updateMessageForView(message: message)
            view?.showMessahe(data: prepairDataForModel())

        /// A new message was received; can also be an outgoing message
        case .updateNewMessage(let updateNewMessage):
            print("******** updateNewMessage *******")
            updateMessageForView(message: updateNewMessage.message)
            view?.showMessahe(data: prepairDataForModel())
            
        /// A request to send a message has reached the Telegram server. This doesn't mean that the message will be sent successfully or even that the send message request will be processed. This update will be sent only if the option "use_quick_ack" is set to true. This update may be sent multiple times for the same message
        case .updateMessageSendAcknowledged(let updateMessageSendAcknowledged):
            print("******** updateMessageSendAcknowledged *******")
        /// A message has been successfully sent
        case .updateMessageSendSucceeded(let updateMessageSendSucceeded):
            print("******** updateMessageSendSucceeded *******")
        /// A message failed to send. Be aware that some messages being sent can be irrecoverably deleted, in which case updateDeleteMessages will be received instead of this update
        case .updateMessageSendFailed(let updateMessageSendFailed):
            print("******** updateChatOnlineMemberCount *******")
        /// The message content has changed
        case .updateMessageContent(let updateMessageContent):
            print("******** updateChatOnlineMemberCount *******")
        /// A message was edited. Changes in the message content will come in a separate updateMessageContent
        case .updateMessageEdited(let updateMessageEdited):
            print("******** updateChatOnlineMemberCount *******")
        /// The message pinned state was changed
        case .updateMessageIsPinned(let updateMessageIsPinned):
            print("******** updateChatOnlineMemberCount *******")
        /// The information about interactions with a message has changed
        case .updateMessageInteractionInfo(let updateMessageInteractionInfo):
            print("******** updateChatOnlineMemberCount *******")
        /// The message content was opened. Updates voice note messages to "listened", video note messages to "viewed" and starts the TTL timer for self-destructing messages
        case .updateMessageContentOpened(let updateMessageContentOpened):
            print("******** updateChatOnlineMemberCount *******")
        /// A message with an unread mention was read
        case .updateMessageMentionRead(let updateMessageMentionRead):
            print("******** updateMessageMentionRead *******")
        /// A message with a live location was viewed. When the update is received, the application is supposed to update the live location
        case .updateMessageLiveLocationViewed(let updateMessageLiveLocationViewed):
            print("******** updateMessageLiveLocationViewed *******")
            
        case .updateUser(let updateUser):
            print("******** updateUser \(updateUser)*******")
            

        case .updateFile(let file):
            print("******** updateFile \(file)*******")
            
            if file.file.local.isDownloadingCompleted {
                loadingFileManager.updateData(newFile: file.file)
            }
            
        default:
            break
        }
    }
    
    func updateNewMessageDelegate(chatId: Int64, message messages: [Message]) {
        if chatId == self.chatId {
            for message in messages {
                updateMessageForView(message: message)
            }
            view?.showMessahe(data: prepairDataForModel())
        }
    }
}

    //MARK: - LoadingFileManagerDelegate
extension ChatPresenter: LoadingFileManagerDelegate {
    func loadingComplite(uniqId: Int64, file: File) {
        guard let photo = UIImage(contentsOfFile: file.local.path) else { return }
        updateMessagesData(messageID: uniqId, text: .photo(PhotoMedia(image: photo, size: photo.size)), userId: nil)
        view?.showMessahe(data: prepairDataForModel())
    }
}

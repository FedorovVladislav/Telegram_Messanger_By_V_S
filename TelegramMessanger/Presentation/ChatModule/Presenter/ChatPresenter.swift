import Foundation
import TdlibKit
import CoreMIDI

protocol ChatViewProtocol: AnyObject {
    func showMessahe(data: [MessageModel])
    var chatTitle: String { get set }
}

protocol ChatPresenterProtocol: AnyObject {
    init(view: ChatViewProtocol, router: RouterProtocol, networkLayer: ChatService, chat: ChatModel)
    func sendMessage(text: String)
    var router: RouterProtocol  { get }
    var networkLayer: ChatService { get }
}

class ChatPresenter: ChatPresenterProtocol {
    weak var view: ChatViewProtocol?
    let router: RouterProtocol
    let networkLayer: ChatService
    var chatId: Int64
    var messageList = [Int64: Message]()
 
    required init(view: ChatViewProtocol, router: RouterProtocol, networkLayer: ChatService, chat: ChatModel) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
        self.chatId = chat.chatId
        if let lastMess = chat.lastMessage {
            self.messageList[lastMess.id] = lastMess
            
        }
        if let title = chat.title {
            
        self.view?.chatTitle =  title
        }
        networkLayer.delegate = self
        networkLayer.getChatMess(chatId: chatId, lastMess: chat.lastMessage?.id)
    }
    
    deinit {
        print("****** ChatViewController deinit *******")
    }
    
    func sendMessage(text: String) {
        networkLayer.sendMess(chatId: chatId, text: text)
    }
    
    private func prepairDataForModel(messageList: [Int64: Message]) -> [MessageModel] {
        var result: [MessageModel] = []
        
        for (id, message) in messageList {
            var text = "Content"
            if case .messageText(let content) = message.content {
                text = content.text.text
            }
            
            var  senderId: Int64 = 0
            if case .messageSenderUser(let sender) = message.senderId {
                senderId = sender.userId
            }
            
            result.append(MessageModel(id: id, text: text, userId: senderId))
        }
        result.sort { $0.id < $1.id }
        return result
    }
    
}

extension ChatPresenter: messDataDelegate {
    func updateData(update: Update) {
        switch update {
            
        case .updateChatLastMessage(let updateChatLastMessage):
            print("******** updateChatLastMessage *******")
            
            guard let message = updateChatLastMessage.lastMessage else { return }
            updateNewMessageDelegate(chatId: updateChatLastMessage.chatId, message: [message])
        
        /// A new message was received; can also be an outgoing message
        case .updateNewMessage(let updateNewMessage):
            print("******** updateNewMessage *******")
            
            updateNewMessageDelegate(chatId: updateNewMessage.message.chatId, message: [updateNewMessage.message])
            
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
            print("******** updateUser *******")

        default:
            break
        }
    }
    
    func updateNewMessageDelegate(chatId: Int64, message messages: [Message]) {
        if chatId == self.chatId {
            for message in messages {
                messageList[message.id] = message
            }
            view?.showMessahe(data: prepairDataForModel(messageList: messageList))
        }
    }
}

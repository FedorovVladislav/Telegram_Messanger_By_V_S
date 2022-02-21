import Foundation
import TdlibKit

protocol messDataDelegate {
  func  messData(updateData: [Message])
}

class ChatService {
    var delegate:  messDataDelegate?
    let api: TdApi
    var chatID: Int64 = 0

    // MARK: - Init
    
    init(tdApi: TdApi){
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = tdApi
    }
    var mess: [Message] = []{
        didSet {
            print("****** mess: \(mess)")
            if mess.count < 20 {
                if let lastmess = mess.last?.id {
                    getChatMess(chatId: chatID, lastMess: lastmess)
                }
            } else {
                delegate?.messData(updateData: mess)
            }
        }
    }
    
    func getChatMess(chatId: Int64, lastMess: Int64) {
        self.chatID = chatId
        try! api.getChatHistory(chatId: chatId, fromMessageId: lastMess, limit: 50, offset: nil, onlyLocal: false, completion: {
            result  in
            switch result{
                
            case .success(_):
                print("Succes")
                let mes = try! result.get().messages
                self.mess =  mes ?? []
            case .failure(_):
                print("failure")
            }
        })
    }

}
extension ChatService: UpdateListeners {
    func updateData(update: Update) {
      
        switch update{
            
        case .updateChatLastMessage(let updateChatLastMessage):
          
            if  chatID == updateChatLastMessage.chatId {
            
            }
            
            if let lastMessage = updateChatLastMessage.lastMessage {
                getChatMess(chatId: chatID, lastMess: lastMessage.id)
            }
            
        /// A new message was received; can also be an outgoing message
        case .updateNewMessage(let updateNewMessage):
            print("******** updateNewMessage *******")
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
        default:
            break
        }
    }
}

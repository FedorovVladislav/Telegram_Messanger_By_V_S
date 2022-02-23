import Foundation
import TdlibKit
import CoreImage

protocol messDataDelegate {
  func  messData(updateData: [Message])
}

class ChatService {
    var delegate:  messDataDelegate?
    let api: TdApi
    var chatId: Int64 = 0
    var userId: Int64 = 0
    var mess: [Message] = []{
        didSet {
            mess.sort { mess1, mess2 in
                mess1.id < mess2.id
            }
            delegate?.messData(updateData: mess)
        }
    }

    // MARK: - Init
    
    init(tdApi: TdApi) {
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = tdApi
    }
    
    func sendMess(text: String){
        //let textEntity = TextEntity(length: 10, offset: 1, type: .textEntityTypeBold)
        let formattedText = FormattedText(entities: [], text: text)
        let inputMessageText =  InputMessageText.init(clearDraft: false, disableWebPagePreview: false, text: formattedText)
        let inputMessageContent = InputMessageContent.inputMessageText(inputMessageText)
        
        try! api.sendMessage(chatId: self.chatId, inputMessageContent: inputMessageContent, messageThreadId: nil, options: nil, replyMarkup: nil, replyToMessageId: nil, completion: {  res in
            print("****res \(res)")
        })
    }
    func getChatMess(chatId: Int64, lastMess: Int64) {
        self.chatId = chatId
        try! api.getChatHistory(chatId: chatId, fromMessageId: nil, limit: 50, offset: nil, onlyLocal: false, completion: {
            result  in
            switch result{
                
            case .success(_):
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
      
        switch update {
            
        case .updateChatLastMessage(let updateChatLastMessage):
            if let lastMessage = updateChatLastMessage.lastMessage {
                getChatMess(chatId: chatId, lastMess: lastMessage.id)
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
            
        case .updateUser(let updateUser):
            print("******** updateUser *******")

        case .updateOption(let updateOption):
            if updateOption.name == "my_id" {
                
                switch updateOption.value {
                case.optionValueInteger(let op):
                    self.userId = op.value.rawValue
            
                default:
                    break
                }
            }
        default:
            break
        }
    }
}

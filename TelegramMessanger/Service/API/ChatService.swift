//
//  ChatService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit

class ChatService {
    
    let api: TdApi

    // MARK: - Init
    
    init(tdApi: TdApi){
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = tdApi
    }
    
    func getChatMess(chatId: Int64) {
       try! api.getChat(chatId:chatId, completion: { result  in
            
            
        })
        
    }

}
extension ChatService: UpdateListeners {
    func updateData(update: Update) {
      
        switch update{
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

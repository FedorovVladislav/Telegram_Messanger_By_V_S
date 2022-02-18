//
//  ChatListService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit

protocol ChatListDelegate {
    func updateChatList(chatDic: [Int64: ChatModel], chatPos: [ChatPositionlist] )
}

struct ChatPositionlist {
    var chatId: Int64
    var position: Int64
    
    init(chatId: Int64, position:Int64) {
        self.chatId = chatId
        self.position = position
    }
  
}

class ChatListService {
    let api: TdApi
    var delegate: ChatListDelegate?
    
    var chatList: [UpdateNewChat]  = [] {
        didSet {
            print ("ChatList changed")
        }
    }
    var  chat: [Chat] = []
    
    var chatDic = [Int64: ChatModel]()
    
    var chatPos: [ChatPositionlist] = [] {
        didSet {
            chatPos.sorted { firstElement, secondElenet in
                return firstElement.position > secondElenet.position
            }
            delegate?.updateChatList(chatDic: chatDic, chatPos: chatPos)
        }
    }
    
    
    // MARK: - Init
    
    init(tdApi: TdApi) {
        self.api = tdApi
    }
    
    func getContact() {
        do  {
            try api.loadChats(chatList: .chatListMain, limit: 30, completion: { result in
                switch result {
                    case .failure(let error ):
                        print ("****** Failure \(error) ******")
      
                    case.success(let ok ):
                       print ("\n \n \n ******     OK   ********** \n \n \n")
                       print(ok)
                    }
                })
        } catch {
            print("******** Chatch error \(error.localizedDescription) *****")
        }
    }
}
extension ChatListService: UpdateListeners {
    
    func updateData(update: Update) {
        
        switch update{
        
        /// A new chat has been loaded/created. This update is guaranteed to come before the chat identifier is returned to the application. The chat field changes will be reported through separate updates
        case .updateNewChat(let newChat):
            if let chat = chatDic[newChat.chat.id] {
                print("***** chatExist ******* ")
            } else {
                let chatpos = newChat.chat.positions
                print("***** addNewItem ******* ")
                
                chatDic[newChat.chat.id] = ChatModel(title: newChat.chat.title, lastMessage: newChat.chat.lastMessage)
            }
        /// The title of a chat was changed
        case .updateChatTitle(let updateChatTitle):
            print("\n ***** updateChatTitle *******")
            
        /// A chat photo was changed
        case .updateChatPhoto(let updateChatPhoto):
            print("***** updateChatPhoto *******")
        /// Chat permissions was changed
        case .updateChatPermissions(let updateChatPermissions):
            print("***** updateChatPermissions *******")
            
        /// The last message of a chat was changed. If last_message is null, then the last message in the chat became unknown. Some new unknown messages might be added to the chat in this case
        case .updateChatLastMessage(let updateChatLastMessage):
            print("***** updateChatLastMessage  \(updateChatLastMessage)*******")
            
            let chatID = updateChatLastMessage.chatId
            
            if let chatPositions = updateChatLastMessage.positions.first?.order.rawValue {
                for ( index, chat )in chatPos.enumerated() {
                    if chatID == chat.chatId {
                        chatPos[index].position = chatPositions
                        print("***** updateChatLastMessage changed *******")
                    break
                    }
                }
            }
            
            if let lastMessage = updateChatLastMessage.lastMessage {
                chatDic[chatID]?.lastMessage = lastMessage
                delegate?.updateChatList(chatDic: chatDic, chatPos: chatPos)
            }
            
        /// The position of a chat in a chat list has changed. Instead of this update updateChatLastMessage or updateChatDraftMessage might be sent
        case .updateChatPosition(let updateChatPosition):
            print("***** updateChatPosition *******")
            //print("***** updateChatPosition \(updateChatPosition) ")
            
            let chatID = updateChatPosition.chatId
            let chatPosition = updateChatPosition.position.order.rawValue
            
            for ( index, chat )in chatPos.enumerated() {
                if chatID == chat.chatId {
                    chatPos[index].position = chatPosition
                    return
                }
            }
            chatPos.append(ChatPositionlist(chatId: chatID, position: chatPosition))
            
        /// The default message sender that is chosen to send messages in a chat has changed
        case .updateChatDefaultMessageSenderId(let updateChatDefaultMessageSenderId):
            print("***** updateChatDefaultMessageSenderId *******")
        /// A chat content was allowed or restricted for saving
        case .updateChatHasProtectedContent(let updateChatHasProtectedContent):
            print("***** updateChatHasProtectedContent *******")
        /// A chat was marked as unread or was read
        case .updateChatIsMarkedAsUnread(let updateChatIsMarkedAsUnread):
            print("***** updateChatIsMarkedAsUnread *******")
        /// A chat was blocked or unblocked
        case .updateChatIsBlocked(let updateChatIsBlocked):
            print("***** updateChatIsBlocked *******")
        /// A chat's has_scheduled_messages field has changed
        case .updateChatHasScheduledMessages(let updateChatHasScheduledMessages):
            print("***** updateChatHasScheduledMessages *******")
        /// A chat video chat state has changed
        case .updateChatVideoChat(let updateChatVideoChat):
            print("***** updateChatVideoChat *******")
        /// The value of the default disable_notification parameter, used when a message is sent to the chat, was changed
        case .updateChatDefaultDisableNotification(let updateChatDefaultDisableNotification):
            print("***** updateChatDefaultDisableNotification *******")
        /// Incoming messages were read or the number of unread messages has been changed
        case .updateChatReadInbox(let updateChatReadInbox):
            print("***** updateChatReadInbox *******")
        /// Outgoing messages were read
        case .updateChatReadOutbox(let updateChatReadOutbox):
            print("***** updateChatReadOutbox *******")
        /// The chat unread_mention_count has changed
        case .updateChatUnreadMentionCount(let updateChatUnreadMentionCount):
            print("***** updateChatUnreadMentionCount *******")
        /// Notification settings for a chat were changed
        case .updateChatNotificationSettings(let updateChatNotificationSettings):
            print("***** updateChatNotificationSettings *******")
        /// Notification settings for some type of chats were updated
        case .updateScopeNotificationSettings(let updateScopeNotificationSettings):
            print("***** updateScopeNotificationSettings *******")
        /// The message Time To Live setting for a chat was changed
        case .updateChatMessageTtlSetting(let updateChatMessageTtlSetting):
            print("***** updateChatMessageTtlSetting *******")
        /// The chat action bar was changed
        case .updateChatActionBar(let updateChatActionBar):
            print("***** updateChatActionBar *******")
        /// The chat theme was changed
        case .updateChatTheme(let updateChatTheme):
            print("***** updateChatTheme *******")
        /// The chat pending join requests were changed
        case .updateChatPendingJoinRequests(let updateChatPendingJoinRequests):
            print("***** updateChatPendingJoinRequests *******")
        /// The default chat reply markup was changed. Can occur because new messages with reply markup were received or because an old reply markup was hidden by the user
        case .updateChatReplyMarkup(let updateChatReplyMarkup):
            print("***** updateChatReplyMarkup *******")
        /// A chat draft has changed. Be aware that the update may come in the currently opened chat but with old content of the draft. If the user has changed the content of the draft, this update mustn't be applied
        case .updateChatDraftMessage(let updateChatDraftMessage):
            print("***** updateChatDraftMessage *******")
        /// The list of chat filters or a chat filter has changed
        case .updateChatFilters(let updateChatFilters):
            print("***** updateChatFilters *******")
        /// The number of online group members has changed. This update with non-zero count is sent only for currently opened chats. There is no guarantee that it will be sent just after the count has changed
        case .updateChatOnlineMemberCount(let updateChatOnlineMemberCount):
            print("***** updateChatOnlineMemberCount *******")
        default:
            break
        }
    }
}

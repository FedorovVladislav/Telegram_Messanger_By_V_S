//
//  ChatListPresenter.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 14.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit
import UIKit

protocol ChatListViewProtocol: AnyObject {
    func updateTableList(chatList: [ChatModel])
}

protocol ChatListPresenterProtocol: AnyObject {
    init(view: ChatListViewProtocol, router: RouterProtocol, networkLayer: ChatListService)
    func openChat(chatID: Int64, lastMess: Message)
    func getContact()
}

class ChatListPresenter: ChatListPresenterProtocol {
    weak var view: ChatListViewProtocol?
    let router: RouterProtocol
    let networkLayer: ChatListService
    var  count: Int = 0
    var chatDic = [Int64: ChatModel]()
    let serialQueue = DispatchQueue(label: "SCGCD", attributes: .init(rawValue: 0))

    required init(view: ChatListViewProtocol, router: RouterProtocol, networkLayer: ChatListService) {
        self.view = view
        self.router = router
        self.networkLayer = networkLayer
        
        networkLayer.delegate = self
    }
    
    func getContact() {
        print("***ButtonWork***")
        networkLayer.getContact()
    }
    
    func openChat(chatID: Int64, lastMess: Message) {
        router.chatVC(chatId: chatID, lastMess: lastMess )
        print(chatID)
    }

    private func prepairDataForModel(chatList: [Int64: ChatModel]) -> [ChatModel] {
        var result: [ChatModel] = []
        
        for (_, chat) in chatList {
            result.append(chat)
        }
        let isSorted = result.sort { chat1, chat2 in
            guard let pos1 = chat1.chatPosition else { return false }
            guard let pos2 = chat2.chatPosition else { return false }
            return pos1.order.rawValue > pos2.order.rawValue
        }
            
        print("  *** is sorted: \(isSorted)")
        return result
    }
    
    private func updateChatDict(chatId: Int64,
                                title: String?,
                                lastMessage: Message?,
                                chatPosition: ChatPosition?) {
        
        if chatDic[chatId] == nil {
            chatDic[chatId] = ChatModel(chatId: chatId, title: title, lastMessage: lastMessage, chatPosition: chatPosition)
        } else {
            if let title = title {
                chatDic[chatId]!.title = title
            }
            if let lastMessage = lastMessage {
                chatDic[chatId]!.lastMessage = lastMessage
            }
            if let chatPosition = chatPosition {
                chatDic[chatId]!.chatPosition = chatPosition
            }
        }
        
        var result: [ChatModel] = []
        
        for (_, chat) in chatDic {
            if chat.chatPosition != nil {
                result.append(chat)
            }
        }
       result.sort { chat1, chat2 in
           guard let pos1 = chat1.chatPosition?.order.rawValue else { return false }
           guard let pos2 = chat2.chatPosition?.order.rawValue else { return false }
            return pos1 > pos2
        }
        print("**** New count result: \(result.count), add  count: \(count) *****")
        for chat in result {
            print("*** ChatID: \(chat.chatId),\t\t\t  ChatPosition: \(chat.chatPosition?.order.rawValue)")
        }
            
        view?.updateTableList(chatList: result)
        
       // view?.updateTableList(chatList: prepairDataForModel(chatList: chatDic))
    }
}

extension ChatListPresenter: ChatListDelegate {
    func updateData(update: Update) {
        
        switch update {

        /// A new chat has been loaded/created. This update is guaranteed to come before the chat identifier is returned to the application. The chat field changes will be reported through separate updates
        case .updateNewChat(let newChat):
            print("\n ***** addNewItem *******")
            count = count + 1
            
            serialQueue.async {
    
                self.updateChatDict(chatId: newChat.chat.id,
                               title: newChat.chat.title,
                               lastMessage: newChat.chat.lastMessage,
                               chatPosition: newChat.chat.positions.first)
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
            print("\n***** updateChatLastMessage  *******")
            
            serialQueue.async {
                self.updateChatDict(chatId: updateChatLastMessage.chatId,
                           title: nil,
                           lastMessage: updateChatLastMessage.lastMessage,
                           chatPosition: updateChatLastMessage.positions.first
                )
            }
    
        /// The position of a chat in a chat list has changed. Instead of this update updateChatLastMessage or updateChatDraftMessage might be sent
        case .updateChatPosition(let updateChatPosition):
            print("\n ***** updateChatPosition *******")
            //print("***** updateChatPosition \(updateChatPosition) ")
            serialQueue.async {
                self.updateChatDict(chatId: updateChatPosition.chatId,
                           title: nil,
                           lastMessage:  nil,
                           chatPosition: updateChatPosition.position)
            }
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
    
//    func updateChatList() {
//        view?.updateTableList(chatList: prepairDataForModel(chatList: chatDic))
//    }
}

//switch update {
//
///// A new chat has been loaded/created. This update is guaranteed to come before the chat identifier is returned to the application. The chat field changes will be reported through separate updates
//case .updateNewChat(let newChat):
//    if let chat = chatDic[newChat.chat.id] {
//        print("***** chatExist ******* ")
//    } else {
//        let chatpos = newChat.chat.positions
//        print("***** addNewItem ******* ")
//
//        chatDic[newChat.chat.id] = ChatModel(title: newChat.chat.title, lastMessage: newChat.chat.lastMessage, lastMessId: newChat.chat.lastMessage?.id)
//    }
///// The title of a chat was changed
//case .updateChatTitle(let updateChatTitle):
//    print("\n ***** updateChatTitle *******")
//
///// A chat photo was changed
//case .updateChatPhoto(let updateChatPhoto):
//    print("***** updateChatPhoto *******")
///// Chat permissions was changed
//case .updateChatPermissions(let updateChatPermissions):
//    print("***** updateChatPermissions *******")
//
///// The last message of a chat was changed. If last_message is null, then the last message in the chat became unknown. Some new unknown messages might be added to the chat in this case
//case .updateChatLastMessage(let updateChatLastMessage):
//    print("***** updateChatLastMessage  \(updateChatLastMessage)*******")
//
//    let chatID = updateChatLastMessage.chatId
//
//    if let chatPositions = updateChatLastMessage.positions.first?.order.rawValue {
//        for ( index, chat )in chatPos.enumerated() {
//            if chatID == chat.chatId {
//                chatPos[index].position = chatPositions
//                print("***** updateChatLastMessage changed *******")
//            break
//            }
//        }
//    }
//
//    if let lastMessage = updateChatLastMessage.lastMessage {
//        chatDic[chatID]?.lastMessage = lastMessage
//        chatDic[chatID]?.lastMessId  = lastMessage.id
//        view?.updateTableList(chatDic: chatDic, chatPos: chatPos)
//    }
//
///// The position of a chat in a chat list has changed. Instead of this update updateChatLastMessage or updateChatDraftMessage might be sent
//case .updateChatPosition(let updateChatPosition):
//    print("***** updateChatPosition *******")
//    //print("***** updateChatPosition \(updateChatPosition) ")
//
//    let chatID = updateChatPosition.chatId
//    let chatPosition = updateChatPosition.position.order.rawValue
//
//    for ( index, chat )in chatPos.enumerated() {
//        if chatID == chat.chatId {
//            chatPos[index].position = chatPosition
//            return
//        }
//    }
//    chatPos.append(ChatPositionlist(chatId: chatID, position: chatPosition))
//
///// The default message sender that is chosen to send messages in a chat has changed
//case .updateChatDefaultMessageSenderId(let updateChatDefaultMessageSenderId):
//    print("***** updateChatDefaultMessageSenderId *******")
///// A chat content was allowed or restricted for saving
//case .updateChatHasProtectedContent(let updateChatHasProtectedContent):
//    print("***** updateChatHasProtectedContent *******")
///// A chat was marked as unread or was read
//case .updateChatIsMarkedAsUnread(let updateChatIsMarkedAsUnread):
//    print("***** updateChatIsMarkedAsUnread *******")
///// A chat was blocked or unblocked
//case .updateChatIsBlocked(let updateChatIsBlocked):
//    print("***** updateChatIsBlocked *******")
///// A chat's has_scheduled_messages field has changed
//case .updateChatHasScheduledMessages(let updateChatHasScheduledMessages):
//    print("***** updateChatHasScheduledMessages *******")
///// A chat video chat state has changed
//case .updateChatVideoChat(let updateChatVideoChat):
//    print("***** updateChatVideoChat *******")
///// The value of the default disable_notification parameter, used when a message is sent to the chat, was changed
//case .updateChatDefaultDisableNotification(let updateChatDefaultDisableNotification):
//    print("***** updateChatDefaultDisableNotification *******")
///// Incoming messages were read or the number of unread messages has been changed
//case .updateChatReadInbox(let updateChatReadInbox):
//    print("***** updateChatReadInbox *******")
///// Outgoing messages were read
//case .updateChatReadOutbox(let updateChatReadOutbox):
//    print("***** updateChatReadOutbox *******")
///// The chat unread_mention_count has changed
//case .updateChatUnreadMentionCount(let updateChatUnreadMentionCount):
//    print("***** updateChatUnreadMentionCount *******")
///// Notification settings for a chat were changed
//case .updateChatNotificationSettings(let updateChatNotificationSettings):
//    print("***** updateChatNotificationSettings *******")
///// Notification settings for some type of chats were updated
//case .updateScopeNotificationSettings(let updateScopeNotificationSettings):
//    print("***** updateScopeNotificationSettings *******")
///// The message Time To Live setting for a chat was changed
//case .updateChatMessageTtlSetting(let updateChatMessageTtlSetting):
//    print("***** updateChatMessageTtlSetting *******")
///// The chat action bar was changed
//case .updateChatActionBar(let updateChatActionBar):
//    print("***** updateChatActionBar *******")
///// The chat theme was changed
//case .updateChatTheme(let updateChatTheme):
//    print("***** updateChatTheme *******")
///// The chat pending join requests were changed
//case .updateChatPendingJoinRequests(let updateChatPendingJoinRequests):
//    print("***** updateChatPendingJoinRequests *******")
///// The default chat reply markup was changed. Can occur because new messages with reply markup were received or because an old reply markup was hidden by the user
//case .updateChatReplyMarkup(let updateChatReplyMarkup):
//    print("***** updateChatReplyMarkup *******")
///// A chat draft has changed. Be aware that the update may come in the currently opened chat but with old content of the draft. If the user has changed the content of the draft, this update mustn't be applied
//case .updateChatDraftMessage(let updateChatDraftMessage):
//    print("***** updateChatDraftMessage *******")
///// The list of chat filters or a chat filter has changed
//case .updateChatFilters(let updateChatFilters):
//    print("***** updateChatFilters *******")
///// The number of online group members has changed. This update with non-zero count is sent only for currently opened chats. There is no guarantee that it will be sent just after the count has changed
//case .updateChatOnlineMemberCount(let updateChatOnlineMemberCount):
//    print("***** updateChatOnlineMemberCount *******")
//default:
//    break
//}

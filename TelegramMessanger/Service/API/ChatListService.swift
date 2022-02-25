import Foundation
import TdlibKit

protocol ChatListDelegate {
    func updateChatList(chatDic: [Int64: ChatModel], chatPos: [ChatPositionlist] )
    func updateData (update: Update)
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
    func updateData (update: Update) {
        delegate?.updateData(update: update)
    }
}

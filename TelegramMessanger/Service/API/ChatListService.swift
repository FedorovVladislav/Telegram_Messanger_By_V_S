import Foundation
import TdlibKit

protocol ChatListDelegate {
   // func updateChatList(chatDic: [Int64: ChatModel], chatPos: [ChatPositionlist] )
    func updateData (update: Update)
}
//
//struct ChatPositionlist {
//    var chatId: Int64
//    var position: Int64
//
//    init(chatId: Int64, position:Int64) {
//        self.chatId = chatId
//        self.position = position
//    }
//}

class ChatListService {
    let api: TdApi
    var delegate: ChatListDelegate?
    
    var photoPath: [Int64:String] =  [:]
    
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
    
    func downloadImage(userID: Int64, remoteId: String?) {

        try!  api.getRemoteFile(fileType:  FileType.fileTypeProfilePhoto, remoteFileId: remoteId ?? "", completion: {
            res in
                      print("****** getRemoteFile:  \(res) ")
            
            switch res {
                
            case .success(let data):
                try! self.api.downloadFile(fileId: data.id, limit:0, offset: 0, priority: 32, synchronous: false, completion: {res in
                  
                    switch res{
                
                    case .success( let data):
                        print("****** downloadFile success:  \(data) ")
                        if data.local.isDownloadingCompleted {
                            self.photoPath[userID] = data.local.path
                            print("****** photoPath  \( self.photoPath.count) ")
                        }
                    case .failure(_):
                        break
                    }
                })
            case .failure(_):
                break
            }
            
        })
        
       
    
}
}

extension ChatListService: UpdateListeners {
    func updateData (update: Update) {
        delegate?.updateData(update: update)
    }
}

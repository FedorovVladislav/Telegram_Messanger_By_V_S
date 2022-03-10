import Foundation
import TdlibKit
import CoreImage
import UIKit

protocol messDataDelegate {
    func updateData (update: Update)
    func updateNewMessageDelegate(chatId: Int64, message: [Message])
}

class ChatService {
    var delegate:  messDataDelegate?
    let api: TdApi
    let telegramService: TelegramService

    // MARK: - Init
    
    init(tdApi: TdApi, telegramService: TelegramService) {
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = tdApi
        self.telegramService = telegramService
    }
    
    func getSenderID() -> Int64 {
        return telegramService.userId
    }
    
    func sendMess(chatId: Int64, text: String) {
        let formattedText = FormattedText(entities: [], text: text)
        let inputMessageText =  InputMessageText.init(clearDraft: false, disableWebPagePreview: false, text: formattedText)
        let inputMessageContent = InputMessageContent.inputMessageText(inputMessageText)
        
        try! api.sendMessage(chatId: chatId, inputMessageContent: inputMessageContent, messageThreadId: nil, options: nil, replyMarkup: nil, replyToMessageId: nil, completion: {  res in })
    }
    
    func getChatMess(chatId: Int64, lastMess: Int64?) {
        try! api.getChatHistory(chatId: chatId, fromMessageId: lastMess ?? nil, limit: 20, offset: nil, onlyLocal: false, completion: { [weak self] result  in
            switch result{
                
            case .success(_):
                print("***** success *****")
                
                guard let data = try! result.get().messages else { return }

                self?.delegate?.updateNewMessageDelegate(chatId: chatId, message: data)
               // self?.mess =  data
            case .failure(_):
                print("******  failure *******")
            }
        })
    }
    
    func downloadImage(remoteId: String?) {

        try!  api.getRemoteFile(fileType:  FileType.fileTypePhoto, remoteFileId: remoteId ?? "", completion: {
            res in
                      print("****** getRemoteFile:  \(res) ")
            
            switch res {
                
            case .success(let data):
                try! self.api.downloadFile(fileId: data.id, limit:0, offset: 0, priority: 32, synchronous: false, completion: {res in
                  
                    switch res{
                
                    case .success( let data):
                        print("****** downloadFile success:  \(data) ")
                        if data.local.isDownloadingCompleted {
                       //     self.photoPath[userID] = data.local.path
                            print("****** photoPath   ")
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

extension ChatService: UpdateListeners {
    func updateData(update: Update) {
        delegate?.updateData(update: update)
    }
}

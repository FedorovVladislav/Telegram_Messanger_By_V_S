import Foundation
import MessageKit

struct MessageModel: MessageType {
    let id: Int64
    var sender: SenderType
    var messageId: String
    var sentDate: MessageKit.Date
    var kind: MessageKind
    
    init(id: Int64, text: String, userId: Int64){
        self.id = id
        self.sender = SenderTypeModel(senderId: userId)
        self.messageId = ""
        self.sentDate = MessageKit.Date(timeIntervalSinceNow: 1)
        self.kind = .text(text)
    }
}

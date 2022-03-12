import Foundation
import MessageKit

struct MessageModel: MessageType {
    let id: Int64
    var sender: SenderType
    var messageId: String
    var sentDate: MessageKit.Date
    var kind: MessageKind
    
    init(id: Int64, text: MessageKind, userId: Int64){
        self.id = id
        self.sender = SenderTypeModel(senderId: userId)
        self.messageId = ""
        self.sentDate = MessageKit.Date(timeIntervalSinceNow: 1)
        self.kind = text
    }
}

struct PhotoMedia: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage = {
        return UIImage(named: "866-8669429_800-x-800-2-loading-clipart")!
    }()
    
    var size: CGSize = {
        return CGSize(width: 50, height: 50)
    }()
    

}

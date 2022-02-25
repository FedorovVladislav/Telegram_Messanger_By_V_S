import Foundation
import MessageKit

struct SenderTypeModel: SenderType {
    var senderId: String
    var displayName: String

    init (senderId: Int64){
        self.senderId = "\(senderId)"
        displayName = ""
    }
}

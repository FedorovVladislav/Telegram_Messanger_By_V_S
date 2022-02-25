//
//  ChatListModel.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 17.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import TdlibKit

struct ChatModel {
    var title: String
    var lastMessage: Message?
    var lastMessId: Int64?
    var chatPosition: ChatPosition? 
}

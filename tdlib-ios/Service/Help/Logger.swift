//
//  Logger.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation

import TdlibKit

public final class StdOutLogger: Logger {
    
    let queue: DispatchQueue
    
    public init() {
        queue = DispatchQueue(label: "Logger", qos: .userInitiated)
    }
    
    public func log(_ message: String, type: LoggerMessageType?) {
        queue.async {
            var fisrtLine = "---------------------------"
            if let type = type {
                fisrtLine = ">> \(type.description): ---------------"
            }
            print("""
                \(fisrtLine)
                \(message)
                ---------------------------
                """)
        }
    }
}

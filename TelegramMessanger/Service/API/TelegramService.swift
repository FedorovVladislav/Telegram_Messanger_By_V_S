//
//  TelegramService.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 11.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit


protocol UpdateListeners: AnyObject {
    func updateData(update: Update)
}

final class TelegramService {
        
    // MARK: - Public properties
       
    let api: TdApi
    
    // MARK: - Private properties
    
    private var listeners: [UpdateListenerWeakBox] = []
       
    // MARK: - Init
    
    init(){
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = TdApi(client: client)
        run()
    }
    deinit{
       // print("**** Deinit *****")
        //
    }
    
    // MARK: - Public Method
    
    func run() {
        api.client.run(updateHandler: { [self] data in
            do {
                
                let update = try self.api.decoder.decode(Update.self, from: data)
                try! updatelisterners(update: update)
                print("\n ************* new Mess *******************\n ")
            } catch {
                print("\n ************* error decode *******************\n ")
            }
        })
    }
    
    func add(listener: UpdateListeners) {
        let box = UpdateListenerWeakBox(value: listener)
        listeners.append(box)
        listeners.compact()
    }
    
    func remove(listener: UpdateListeners) {
        var listenerIndex: Int = -1
        for (index, existingListener) in listeners.enumerated() {
            if listener === existingListener.value {
                listenerIndex = index
                break
            }
        }
        if listenerIndex >= 0 {
            listeners.remove(at: listenerIndex)
        }
        listeners.compact()
    }
    
    // MARK: - Private Method
    
    private func updatelisterners(update: Update) throws {
        for listener in listeners {
            listener.value?.updateData(update: update)
        }
    }
}

final class UpdateListenerWeakBox {
    private(set) weak var value: UpdateListeners?

    init(value: UpdateListeners?) {
        self.value = value
    }
}

private extension Array where Element == UpdateListenerWeakBox {
    mutating func compact() {
        self = self.filter { $0.value != nil }
    }
}

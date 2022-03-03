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
    var userId: Int64 = 0
    
    // MARK: - Private properties
    
    private var listeners: [UpdateListenerWeakBox] = []
  
    // MARK: - Init
    
    init(){
        let client = TdClientImpl(completionQueue: .main, logger: StdOutLogger())
        self.api = TdApi(client: client)
        run()
      
    }
    deinit{
        print("**** Deinit *****")
        
    }
    
    // MARK: - Public Method
    
    func run() {
        api.client.run(updateHandler: { [self] data in
            do {
                
                let update = try self.api.decoder.decode(Update.self, from: data)
                try! updatelisterners(update: update)
                print("\n ************* new Mess : \(update) ******************* \n ")
                switch  update {
                    
                case .updateOption(let updateOption):
                    if updateOption.name == "my_id" {
                    
                    switch updateOption.value {
                    case.optionValueInteger(let op):
                        self.userId = op.value.rawValue
                    
                
                    default:
                        break
                    }
                        
                }
//                case  .updateAuthorizationState( let updateAuthorizationState):
//                    switch updateAuthorizationState.authorizationState {
////                    case .authorizationStateReady:
////                        serialQueue.async {
////                            try! self.api.getContacts(completion: { res in
////                                print("****** getContacts:  \(res) ")
////                                 switch res {
////
////                                 case .success(let users):
////                                     for user in users.userIds {
////                                         self.getImage(userID: user)
////                                     }
////
////                                 case .failure(_):
////                                     break
////                                 }
////                            })
////                        }
//
//                    default:
//                        break
//                    }
                //case .updateFile(<#T##UpdateFile#>)
                default:
                    break
                }
                    
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
    
//    func getImage(userID: Int64) {
//
//        try! api.getUserProfilePhotos(limit: 1, offset: nil, userId: userID, completion: {
//            res in
//            print("****** getImage:  \(res) ")
//
//            switch res{
//
//            case .success(let data):
//                if  let photo = data.photos.first?.sizes.first?.photo {
//                    if photo.local.isDownloadingCompleted {
//                        self.photoPath[userID] = photo.local.path
//                        print("****** photoPath  \( self.photoPath.count) ")
//                }
//                    self.downloadImage(userID: userID, remoteId: photo.remote.id)
//                } else {
//                    print("****** cant get photo:  \(res) ")
//                }
//            case .failure(_):
//                break
//            }
//        })
//    }
    
   
       
    
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

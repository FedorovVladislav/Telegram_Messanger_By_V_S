//
//  LoadingManager.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 12.03.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import Foundation
import TdlibKit

protocol LoadingFileManagerDelegate {
    func loadingComplite(uniqId: Int64, file: File)
}

class LoadingFileManager {
    let networkLayer: ChatService
    var loadingFies = [String: Int64]()
    var delegate: LoadingFileManagerDelegate?
    
    init(networkLayer: ChatService) {
        self.networkLayer = networkLayer
    }
    
    func startLoading(uniqId: Int64, file: File) {
        loadingFies[file.remote.uniqueId] = uniqId
        networkLayer.downloadImage(remoteId: file.remote.id)
    }
    
    func updateData(newFile: File) {
        if let uniqId = loadingFies[newFile.remote.uniqueId] {
            delegate?.loadingComplite(uniqId: uniqId, file: newFile)
            loadingFies[newFile.remote.uniqueId] = nil
        }
    }
}

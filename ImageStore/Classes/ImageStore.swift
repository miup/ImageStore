//
//  ImageStore.swift
//  ImageStore
//
//  Created by miup on 2017/08/01.
//

import Foundation

struct ImageStoreConfig {
    let maxDownloadSize: UInt64
    let cacheLimit: UInt64

    init(maxDownloadSize: UInt64 = UInt64(2e8), cacheLimit: UInt64 = UInt64(200e8)) {
        self.maxDownloadSize = maxDownloadSize
        self.cacheLimit = cacheLimit
    }
}

class ImageStore {
    private(set) static var shared: ImageStore = ImageStore(ImageStoreConfig())

    class func reset(config: ImageStoreConfig = ImageStoreConfig()) {
        shared = ImageStore(config)
    }

    let config: ImageStoreConfig

    private init(_ config: ImageStoreConfig) {
        self.config = config
    }
}

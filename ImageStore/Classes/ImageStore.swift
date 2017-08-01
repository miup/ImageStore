//
//  ImageStore.swift
//  ImageStore
//
//  Created by miup on 2017/08/01.
//

import UIKit

struct ImageStoreConfig {

    let maxDownloadSize: Int64
    let cacheLimit: Int64

    init(maxDownloadSize: Int64 = Int64(2e8), cacheLimit: Int64 = Int64(200e8)) {
        self.maxDownloadSize = maxDownloadSize
        self.cacheLimit = cacheLimit
    }
}

final class ImageStore: NSObject {

    private(set) static var shared: ImageStore = ImageStore(ImageStoreConfig())

    class func reset(config: ImageStoreConfig = ImageStoreConfig()) {
        shared = ImageStore(config)
    }


    let config: ImageStoreConfig
    let cache: NSCache<AnyObject, UIImage> = NSCache()

    private init(_ config: ImageStoreConfig) {
        self.config = config
        cache.totalCostLimit = Int(self.config.cacheLimit)
        cache.name = "ImageStore.ImageStore.cache"
    }

    func load(_ url: URL, completion: ((UIImage?) -> Void)?) {
        if let cachedImage: UIImage = cache.object(forKey: url.absoluteString as AnyObject) {
            completion?(cachedImage)
            return
        }

        
    }

}

extension ImageStore: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let image: UIImage = obj as? UIImage {
            print(image)
        }
    }
}

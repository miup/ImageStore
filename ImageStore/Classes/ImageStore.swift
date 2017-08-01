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

    typealias ImageStoreCompletionHandler = ((UIImage?) -> Void)

    private(set) static var shared: ImageStore = ImageStore(ImageStoreConfig())

    class func reset(config: ImageStoreConfig = ImageStoreConfig()) {
        shared = ImageStore(config)
    }


    let config: ImageStoreConfig
    let cache: NSCache<AnyObject, UIImage> = NSCache()
    let queue: DispatchQueue = DispatchQueue(label: "ImageStore.ImageStore.queue")
    var completionsByURLString: [String: [ImageStoreCompletionHandler]] = [:]

    private init(_ config: ImageStoreConfig) {
        self.config = config
        cache.totalCostLimit = Int(self.config.cacheLimit)
        cache.name = "ImageStore.ImageStore.cache"
    }

    func load(_ url: URL, completion: ImageStoreCompletionHandler?) {
        if let cachedImage: UIImage = cache.object(forKey: url.absoluteString as AnyObject) {
            completion?(cachedImage)
            return
        }

        if let completion = completion {
            if let completions: [ImageStoreCompletionHandler] = completionsByURLString[url.absoluteString] {
                var newCompletions = completions
                newCompletions.append(completion)
                completionsByURLString[url.absoluteString] = newCompletions
            } else {
                completionsByURLString[url.absoluteString] = [completion]
            }
        }

        queue.async { [weak self] in
            guard let `self` = self else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: url.absoluteString as AnyObject)
                if let completions: [ImageStoreCompletionHandler] = self.completionsByURLString[url.absoluteString] {
                    completions.forEach { $0(image) }
                    self.completionsByURLString[url.absoluteString] = []
                }
            } catch {
                print("[ImageStore] can't get data from url")
            }
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

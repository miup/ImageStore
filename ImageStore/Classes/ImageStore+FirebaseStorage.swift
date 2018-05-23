//
//  ImageStore+FirebaseStorage.swift
//  ImageStore_Example
//
//  Created by kazuya-miura on 2017/09/07.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import FirebaseStorage

extension ImageStore {
    public func load(storageReference: StorageReference, completion: ImageStoreCompletionHandler? = nil) {
        if let cachedImage: UIImage = cache.object(forKey: storageReference.fullPath as AnyObject) {
            completion?(cachedImage, nil)
            return
        }

        storageReference.downloadURL { [weak self] (url, error) in
            guard let url: URL = url else { return }
            self?.load(url) { (image, error) in
                guard let image = image else { completion?(nil, error); return  }
                self?.cache.setObject(image, forKey: storageReference.fullPath as AnyObject)
                completion?(image, nil)
            }
        }
    }
}

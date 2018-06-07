//
//  UIImageView+FirebaseStorage.swift
//  ImageStore_Example
//
//  Created by kazuya-miura on 2017/09/28.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FirebaseStorage

extension UIImageView {
    @nonobjc public func load(_ storageReference: StorageReference, placeholderImage: UIImage? = nil, shouldResetImageWhenLoading: Bool = true, shouldSetImageConditionBlock: @escaping (() -> Bool) = { return true } ) {
        if let placeholderImage = placeholderImage {
            image = placeholderImage
        } else if shouldResetImageWhenLoading {
            image = placeholderImage
        }

        ImageStore.shared.load(storageReference: storageReference) { [weak self] (image, error) in
            if let error = error {
                debugPrint("[ImageStore] load image error:", error)
                return
            }

            guard let `self` = self else { return }
            if shouldSetImageConditionBlock() {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

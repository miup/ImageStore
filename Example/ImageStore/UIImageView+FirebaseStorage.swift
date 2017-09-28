//
//  UIImageView+FirebaseStorage.swift
//  ImageStore_Example
//
//  Created by kazuya-miura on 2017/09/28.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ImageStore
import FirebaseStorage

extension UIImageView {
    public func load(_ storageReference: StorageReference, shouldSetImageConditionBlock: @escaping (() -> Bool) = { return true } ) {
        ImageStore.shared.load(storageReference: storageReference) { [weak self] image in
            guard let `self` = self else { return }
            if shouldSetImageConditionBlock() {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}

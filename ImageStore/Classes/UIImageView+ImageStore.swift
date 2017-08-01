//
//  UIImageView+ImageStore.swift
//  ImageStore
//
//  Created by miup on 2017/08/01.
//

import UIKit

extension UIImageView {
    func load(_ url: URL, shouldSetImageConditionBlock: @escaping (() -> Bool) = { return true } ) {
        ImageStore.shared.load(url) { image in
            if shouldSetImageConditionBlock() {
                self.image = image
            }
        }
    }
}

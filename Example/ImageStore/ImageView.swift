//
//  ImageView.swift
//  ImageStore_Example
//
//  Created by miup on 2017/08/01.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

/***
 This class is a sample for usage of ImageStore with ImageView.
 ***/


import UIKit
import ImageStore

class ImageView: UIImageView {

    var url: URL?

    /**
     you can use this method when download a image from URL.
     2nd argument shoulSetImageConditionBlock is closure that returns a condition allow ImageView to display image.
     **/
    public func load(_ url: URL, shouldSetImageConditionBlock: @escaping (() -> Bool) = { return true } ) {
        self.url = url
        _ = ImageStore.shared.load(url) { image in
            if shouldSetImageConditionBlock() {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }

    /**
     you can cancel download task using this function.
     If you call this function, task is canceled and destroyed.
     If you want to resume the task later, use function suspendLoading().
     **/
    func cancelLoading() {
        guard let url: URL = url else { return }
        ImageStore.shared.cancel(url: url)
    }

    /**
     you can suspend download task using this function.
     If you resume download task, call the function load(_ url: URL, shouldSetImageConditionBlock: @escaping (() -> Bool))
     If suspended task is exist, resume task.
     If suspended task is not exist, new task is created and start downloading.
     **/
    func suspendLoading() {
        guard let url: URL = url else { return }
        ImageStore.shared.suspendIfResuming(url: url)
    }
}

//
//  UIImageView+ImageStore.swift
//  ImageStore
//
//  Created by kazuya-miura on 2017/09/07.
//

import UIKit
import FirebaseStorage

extension UIImageView {

    private struct AssociatedKeys {
        static var url: UInt8 = 1
    }

    private var _url: URL? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.url) as? URL else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.url, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     you can use this method when download a image from URL.
     2nd argument shoulSetImageConditionBlock is closure that returns a condition allow ImageView to display image.
     **/
    @nonobjc public func load(_ url: URL, placeholderImage: UIImage? = nil, shouldResetImageWhenLoading: Bool = true, shouldSetImageConditionBlock: @escaping (() -> Bool) = { return true } ) {
        _url = url
        if let placeholderImage = placeholderImage {
            image = placeholderImage
        } else if shouldResetImageWhenLoading {
            image = placeholderImage
        }

        _ = ImageStore.shared.load(url) { [weak self] (image, error) in
            if let error = error {
                debugPrint("[ImageStore] load image error:", error)
                return
            }

            guard let `self` = self else { return }
            if shouldSetImageConditionBlock() {
                DispatchQueue.main.async {
                    if let image = image {
                        self.image = image
                    }
                }
            }
        }
    }

    /**
     you can cancel download task using this function.
     If you call this function, task is canceled and destroyed.
     If you want to resume the task later, use function suspendLoading().
     **/
    public func cancelLoading() {
        guard let url: URL = _url else { return }
        ImageStore.shared.cancel(url: url)
    }

    /**
     you can suspend download task using this function.
     If you resume download task, call the function load(_ url: URL, shouldSetImageConditionBlock: @escaping (() -> Bool))
     If suspended task is exist, resume task.
     If suspended task is not exist, new task is created and start downloading.
     **/
    public func suspendLoading() {
        guard let url: URL = _url else { return }
        ImageStore.shared.suspendIfResuming(url: url)
    }
}

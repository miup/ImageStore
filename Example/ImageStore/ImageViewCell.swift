//
//  ImageViewCell.swift
//  ImageStore_Example
//
//  Created by miup on 2017/08/01.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import ImageStore

class ImageViewCell: UITableViewCell {
    static let cellIdentifier: String = "ImageViewCell"
    static let cellHeight: CGFloat = UIScreen.main.bounds.width

    var id: String?

    @IBOutlet weak var photoImageView: ImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        id = nil
        photoImageView.image = nil
        photoImageView.suspendLoading()
    }

}

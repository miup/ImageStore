//
//  ViewController.swift
//  ImageStore
//
//  Created by miup on 08/01/2017.
//  Copyright (c) 2017 miup. All rights reserved.
//

import UIKit
import ImageStore

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let urls: [URL] = [
        // input test image urls.
    ]


    override func loadView() {
        super.loadView()
        tableView.rowHeight = ImageViewCell.cellHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageViewCell.cellIdentifier, for: indexPath) as? ImageViewCell else { return UITableViewCell() }
        let url = urls[indexPath.row]
        let urlString = url.absoluteString
        cell.id = urlString
        cell.photoImageView.load(url) {
            return cell.id == urlString
        }

        return cell
    }
}

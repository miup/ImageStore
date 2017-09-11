# ImageStore

[![CI Status](http://img.shields.io/travis/miup/ImageStore.svg?style=flat)](https://travis-ci.org/miup/ImageStore)
[![Version](https://img.shields.io/cocoapods/v/ImageStore.svg?style=flat)](http://cocoapods.org/pods/ImageStore)
[![License](https://img.shields.io/cocoapods/l/ImageStore.svg?style=flat)](http://cocoapods.org/pods/ImageStore)
[![Platform](https://img.shields.io/cocoapods/p/ImageStore.svg?style=flat)](http://cocoapods.org/pods/ImageStore)

ImageStore is image downloader with memory cache supporting.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements
- Swift3.2
- iOS10.0 or higher

## Installation

ImageStore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ImageStore"
```

## Classes, Structs, extensions
### ImageStoreConfig
ImageStore's config struct.

#### property
- maxDownloadSize<br>
Max download size at one image. (default 2MB)

- cacheLimit<br>
Cache size. (default 200MB)

#### methods
- `init(maxDownloadSize: Int64, cacheLimit: Int64)`


### ImageStore
Image downloader class.

#### property
- `shared: ImageStore` (static)<br>
Singleton shared instance.

- `config: ImageStoreConfig`<br>
ImageStore's config.

- `completionsByURLString: [String: [ImageStoreCompletionHandler]]`<br>
Completion handlers dictionary indexed by source URL String.

- `downloadTaskByURLString: [String: URLSessionDownloadTask]`<br>
Download task dictionary indexed by source URL String.

- `cache: NSCache<AnyObject, UIImage>`<br>
Image cache.

- `queue: OperationQueue`<br>
Image download queue.

- `session: URLSession`<br>
Image download URLSesson.

#### methods

- `reset(config: ImageStoreConfig)` (class)<br>
Create new shared instance from ImageStoreConfig.

- `load(_ url: URL, completion: ImageStoreCompletionHandler?)`<br>
Download image from URL, and execute CompletionHandler. If cached, only execute CompletionHandler.<br>
If download task has suspended, resume it.<br>
```Swift
let url = URL(string: "your.images.com/0.jpg")

ImageStore.shared.load(url) { [weak self] image in
    self?.myImageView.image = image
}

ImageStore.shared.load(url) { [weak self] image in
    self?.mySecondImageView.image = image
}
```

If you write like this, only one download task is create. But two completion handlers are executed.

- `suspendIfResuming(url: URL)`<br>
If ImageStore has download task with argument URL and it resuming, suspend it.<br>
You can resume it `load(url)` function.

- `cancel(url: URL)`<br>
Remove download task with argument URL.

### UIImageView+ImageStore
UIImageView extension for using ImageStore.

#### methods
- `load(_ url: URL, shouldSetImageConditionBlock: @escaping (() -> Bool))`<br>
Second argument `shoulSetImageConditionBlock` is closure that returns a condition allow ImageView to display image.<br>
It needs for resusable view (e.g. UITableViewCell, UICollectionViewCell).<br>
When reused thats views, you may change iamge of cell's ImageView.<br>
You must call `suspendIfResuming(url: URL)` or `cancel(url: URL)` at cell's `prepareForReuse` function.<br>
But `suspendIfResuming(url: URL)` and `cancel(url: URL)` does not delete completion handler for resume or next downloading.<br>
So if executed completion handler between after `prepareForReuse` and next download image completion handler, previous image has displayed till call next download is end.<br>
Look follow example.

```Swift
class MyTableViewCell: UITableViewCell {
    static let cellIdentifier = "MyTableViewCell"
    var id: String?
    var myImageView: UIImageView = UIImageView()

    override func prepareForReuse() {
        super.prepareForReuse()
        id = nil
        myImageView.image = nil
        myImageView.suspendLoading()
    }
}

class MyListViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.cellIdentifier, for: indexPath) as? MyViewCell else { return UITableViewCell() }
        let url = urls[indexPath.row]
        let urlString = url.absoluteString
        cell.id = urlString
        cell.myImageView.load(url) {
            // display image if cell's id and loading image url string is match.
            return cell.id == urlString
        }

        return cell
    }
}
```

- `cancelLoading()`<br>
Cancel current url loading.

- `suspendLoading()`<br>
Suspend current url loading.

### Others
You can use ImageStore with FirebaseStorage.<br>
Look [ImageStore/Example/ImageStore/ImageStore+FirebaseStorage.swift](https://github.com/miuP/ImageStore/blob/master/Example/ImageStore/ImageStore%2BFirebaseStorage.swift)<br>
If podspec can use static framework as dependency, this file will be included this pod.

## Author

miup, contact@miup.blue

## License

ImageStore is available under the MIT license. See the LICENSE file for more info.

## Contribution
- If you found a bug, please open an issue.
- I'm wating for your feature request, pelase open an issue.
- I'm wating for your contribution, please create a new pull request.

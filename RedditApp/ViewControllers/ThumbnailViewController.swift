//  RedditApp

import UIKit

class ThumbnailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    private var storedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restorationIdentifier = "thumbnailViewController"
        restorationClass = ThumbnailViewController.self
    }
    
    @IBAction func saveImageAction(_ sender: Any) {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let image = imageView.image {
            coder.encode(image, forKey: "storedImage")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let image = coder.decodeObject(forKey: "storedImage") as? UIImage {
            storedImage = image
        }
        
        super.decodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        if let image = storedImage {
            imageView.image = image
        }
    }
}

extension ThumbnailViewController: UIViewControllerRestoration {
    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        let vc = ThumbnailViewController()
        return vc
    }
}

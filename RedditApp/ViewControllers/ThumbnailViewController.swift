//  RedditApp

import UIKit

class ThumbnailViewController: UIViewController {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBAction func saveImageAction(_ sender: Any) {
        if let image = thumbnailImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

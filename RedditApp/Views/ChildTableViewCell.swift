// ChildTableViewCell.swift

import Foundation
import UIKit

class ChildTableViewCell: UITableViewCell {
    @IBOutlet weak var linkTitleLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var timeAndAuthorLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    private var thumbnailPath: String!
    
    func configure(viewModel: ChildTableViewCellViewModel) {
        linkTitleLabel.text = viewModel.title
        timeAndAuthorLabel.text = "\(viewModel.timeSincePosted) ago by \(viewModel.author)"
        commentCountLabel.text = "\(viewModel.commentCount) comments"
        configureThumbnail(thumbnailPath: viewModel.thumbnailPath)
        thumbnailPath = viewModel.thumbnailPath
    }
    
    func configureThumbnail(thumbnailPath: String) {
        guard thumbnailPath.contains("redditmedia") else {
            thumbnail.isHidden = true
            return
        }
        
        let path = URL(string: thumbnailPath)!
        let task = URLSession.shared.dataTask(with: path, completionHandler: { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.thumbnail.image = image
                    self.thumbnail.isHidden = false
                }
            }
        })
        task.resume()
    }
    
    @IBAction func thumbnailButtonAction(_ sender: Any) {
    }
    
    override func prepareForReuse() {
        thumbnail.image = nil
        thumbnail.isHidden = false
        super.prepareForReuse()
    }
}

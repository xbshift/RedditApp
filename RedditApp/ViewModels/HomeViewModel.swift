// HomeViewModel.swift

import Foundation
import UIKit

class ChildTableViewCellViewModel {
    var title: String
    var commentCount: String
    var timeSincePosted: String
    var author: String
    var thumbnailPath: String

    init(_ link: Link) {
        title = link.title
        author = link.author
        commentCount = String(link.numComments)
        timeSincePosted = Services.date.timeSincePosted(time: link.created)
        thumbnailPath = link.thumbnail
    }
}

class ChildTableViewCell: UITableViewCell {
    @IBOutlet weak var linkTitleLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var timeAndAuthorLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    func config(viewModel: ChildTableViewCellViewModel) {
        linkTitleLabel.text = viewModel.title
        timeAndAuthorLabel.text = "\(viewModel.timeSincePosted) ago by \(viewModel.author)"
        commentCountLabel.text = "\(viewModel.commentCount) comments"
        configureThumbnail(thumbnailPath: viewModel.thumbnailPath)
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
    
    override func prepareForReuse() {
        thumbnail.image = nil
        thumbnail.isHidden = false
        super.prepareForReuse()
    }
}

class HomeViewModel: NSObject {
    var children = [Children]()
    
    func getChildren() {
        Services.req.requestJSON() { children in
            self.children = children
        }
    }
}

extension HomeViewModel: UITableViewDelegate {
}

extension HomeViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return children.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildTableViewCell", for: indexPath) as! ChildTableViewCell
        let child = children[indexPath.row]
        let viewModel = ChildTableViewCellViewModel(child.data)
        cell.config(viewModel: viewModel)
        return cell
    }
}

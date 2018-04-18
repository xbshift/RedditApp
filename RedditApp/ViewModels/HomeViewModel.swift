// HomeViewModel.swift

import Foundation
import UIKit

class ChildTableViewCellViewModel {
    var title: String
    var commentCount: String
//    var timeSincePosted: String
    var author: String
    
    init(_ link: Link) {
        title = link.title
        author = link.author
        commentCount = String(link.numComments)
//        timeSincePosted = link.created
    }
    
    func calculateTimeSincePostedString(time: Int) -> String {
        let dateFormatter = DateFormatter()
        
//        dateFormatter.timeZone = TimeZone(abbreviation: "PS)
        return ""
    }
    
}
class ChildTableViewCell: UITableViewCell {
    @IBOutlet weak var linkTitleLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var timeAndAuthorLabel: UILabel!
    
    func config(viewModel: ChildTableViewCellViewModel) {
        linkTitleLabel.text = viewModel.title
        timeAndAuthorLabel.text = "12 days ago by \(viewModel.author)"
        commentCountLabel.text = "\(viewModel.commentCount) comments"
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

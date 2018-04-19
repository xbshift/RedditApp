// HomeViewModel.swift

import Foundation
import UIKit

class HomeViewModel: NSObject {
    var children = [Children]()
    weak var delegate: HomeViewModelDelegate?
    
    func getChildren() {
        Services.req.requestJSON() { children in
            self.children = children
        }
    }
    
    func showImage(path: String) {
        delegate?.didReceiveThumbnailTap(path: path)
    }
}

protocol HomeViewModelDelegate: class {
    func didReceiveThumbnailTap(path: String)
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
        cell.configure(viewModel: viewModel)
        
        cell.thumbnailButtonTapHandler = { [unowned self] _ in
            self.showImage(path: viewModel.thumbnailPath)
        }
        
        return cell
    }
}

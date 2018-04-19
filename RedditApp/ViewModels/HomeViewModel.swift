// HomeViewModel.swift

import Foundation
import UIKit

class HomeViewModel: NSObject {
    var currentAfter: String?
    var children = [Children]()
    weak var delegate: HomeViewModelDelegate?
    
    func showImage(path: URL) {
        delegate?.didReceiveThumbnailTap(path: path)
    }
    
    func paginate(indexPath: IndexPath) {
        guard indexPath.item == children.count - 1 else { return }
        Services.req.requestJSON(limit: 50, pagingAfter: currentAfter) { newListing in
            self.children += newListing.children
            self.currentAfter = newListing.after
            DispatchQueue.main.async {
                self.delegate?.didPaginate()
            }
        }
    }
}

protocol HomeViewModelDelegate: class {
    func didReceiveThumbnailTap(path: URL)
    func didPaginate()
}

extension HomeViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        paginate(indexPath: indexPath)
    }
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
            if let imagePath = viewModel.imagePath {
                self.showImage(path: imagePath)
            }
        }
        
        return cell
    }
}

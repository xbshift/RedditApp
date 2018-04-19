// HomeViewModel.swift

import Foundation
import UIKit

class HomeViewModel: NSObject, Codable {
    var currentAfter: String?
    var children = [Children]()
    weak var delegate: HomeViewModelDelegate?
    
    enum CodingKeys: String, CodingKey {
        case currentAfter
        case children
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentAfter = try container.decodeIfPresent(String.self, forKey: .currentAfter) ?? nil
        children = try container.decodeIfPresent([Children].self, forKey: .children) ?? [Children]()
    }
    
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

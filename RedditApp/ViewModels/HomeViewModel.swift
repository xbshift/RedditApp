// HomeViewModel.swift

import Foundation
import UIKit

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
        cell.configure(viewModel: viewModel)
        return cell
    }
}

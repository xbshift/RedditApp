//  HomeViewController.swift

import Foundation
import UIKit

class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(UINib(nibName: "ChildTableViewCell", bundle: nil), forCellReuseIdentifier: "ChildTableViewCell")
        
        Services.req.requestJSON(limit: 50) { listing in
            self.viewModel.currentAfter = listing.after
            self.viewModel.children = listing.children
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didPaginate() {
        self.tableView.reloadData()
    }
    
    func didReceiveThumbnailTap(path: String) {
        guard let path = URL(string: path) else { return }
        let task = URLSession.shared.dataTask(with: path, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let thumbnailViewController = storyboard.instantiateViewController(withIdentifier: "thumbnailViewController") as? ThumbnailViewController else { return }
                    let _ = thumbnailViewController.view
                    thumbnailViewController.thumbnailImageView.image = image
                    self.navigationController?.pushViewController(thumbnailViewController, animated: true)
                }
            }
        })
        task.resume()
    }
}

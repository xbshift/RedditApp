//  HomeViewController.swift

import Foundation
import UIKit

class HomeViewController: UIViewController {
    var viewModel = HomeViewModel()
    @IBOutlet weak var tableView: UITableView!
    private var storedIndexPath: IndexPath?
    private var storedScrollPosition: UITableViewScrollPosition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        restorationIdentifier = "homeViewController"
//        restorationClass = HomeViewController.self
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
    
//    override func encodeRestorableState(with coder: NSCoder) {
//        coder.encode(viewModel, forKey: "storedHomeViewModel")
//        coder.encode(tableView.indexPathsForVisibleRows?.first, forKey: "storedIndexPath")
//        coder.encode(tableView.contentOffset.y, forKey: "storedScrollPosition")
//        super.encodeRestorableState(with: coder)
//    }
//
//    override func decodeRestorableState(with coder: NSCoder) {
//        viewModel = coder.decodeObject(forKey: "storedHomeViewModel") as! HomeViewModel
//        storedIndexPath = coder.decodeObject(forKey: "storedIndexPath") as? IndexPath
//        if let yValue = coder.decodeObject(forKey: "storedScrollPosition") as? Int {
//            storedScrollPosition = UITableViewScrollPosition(rawValue: yValue)
//        }
//        super.decodeRestorableState(with: coder)
//    }
    
//    override func applicationFinishedRestoringState() {
//        tableView.reloadData()
//        guard
//            let storedIndexPath = self.storedIndexPath,
//            let storedScrollPosition = self.storedScrollPosition
//        else { return }
//
//        tableView.scrollToRow(at: storedIndexPath, at: storedScrollPosition, animated: false)
//    }
}

//extension HomeViewController: UIViewControllerRestoration {
//    static func viewController(withRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
//        let vc = HomeViewController()
//        return vc
//    }
//}

extension HomeViewController: HomeViewModelDelegate {
    func didPaginate() {
        self.tableView.reloadData()
    }
    
    func didReceiveThumbnailTap(path: URL) {
        let task = URLSession.shared.dataTask(with: path, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let thumbnailViewController = storyboard.instantiateViewController(withIdentifier: "thumbnailViewController") as? ThumbnailViewController else { return }
                    let _ = thumbnailViewController.view
                    thumbnailViewController.imageView.image = image
                    self.navigationController?.pushViewController(thumbnailViewController, animated: true)
                }
            }
        })
        task.resume()
    }
}

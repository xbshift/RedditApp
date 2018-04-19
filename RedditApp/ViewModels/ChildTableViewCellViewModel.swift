//  ChildTableViewCellViewModel.swift

import Foundation

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

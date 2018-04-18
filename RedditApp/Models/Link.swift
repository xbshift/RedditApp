//  Link.swift

import Foundation

struct RedditImage: Codable {
    var resolutions: [RedditImageInfo]
    var source: RedditImageInfo
}

struct RedditImageInfo: Codable {
    var url: String
    var width: Int
    var height: Int
}

struct Link: Codable {
    //    var selftextHtml: String
    //    var permalink: String
    var author: String
    var title: String
    var subreddit: String
    var thumbnail: String
    var numComments: Int
    var created: Int
    var score: Int
    var url: String
}

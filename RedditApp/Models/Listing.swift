// Listing.swift

import Foundation

struct Listing: Codable {
    var after: String?
    var before: String?
    var children: [Children]
}

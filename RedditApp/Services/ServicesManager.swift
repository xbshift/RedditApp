//  ServicesManager.swift

import Foundation

let Services = ServicesManager.sharedInstance

final class ServicesManager {
    static let sharedInstance = ServicesManager()
    
    var req = RequestService()
    var date = DateService()
}

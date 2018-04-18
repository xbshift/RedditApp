//  DateService.swift

import Foundation

final class DateService {
    let formatter: DateComponentsFormatter
    
    init() {
        formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.maximumUnitCount = 1
    }
    
    func timeSincePosted(time: Int) -> String {
        let pastDate = Date(timeIntervalSince1970: Double(time))
        let currentDate = Date()
        return formatter.string(from: pastDate, to: currentDate) ?? "Unknown hours ago"
    }
}

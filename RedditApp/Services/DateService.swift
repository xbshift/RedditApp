//  DateService.swift

import Foundation

final class DateService {
    let formatter: DateFormatter
    let componentsFormatter: DateComponentsFormatter
    
    init() {
        formatter = DateFormatter()
        componentsFormatter = DateComponentsFormatter()
        componentsFormatter.unitsStyle = .full
        componentsFormatter.allowedUnits = [.year, .month, .day, .hour]
        componentsFormatter.maximumUnitCount = 1
        componentsFormatter.calendar = Calendar.current
    }
    
    func timeSincePosted(time: Int) -> String {
        let pastDate = Date(timeIntervalSince1970: TimeInterval(time))
        let currentDate = Date()
        return componentsFormatter.string(from: pastDate, to: currentDate) ?? "Unknown hours ago"
    }
}

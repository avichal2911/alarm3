import Foundation

enum AlarmMode: String, Codable {
    case oneTime
    case weekly
}

struct Alarm: Identifiable, Codable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    
    var hour: Int
    var minute: Int
    var isAM: Bool
    
    var mode: AlarmMode
    var date: Date?
    var daysOfWeek: [Int]?
    
    var description: String
    var soundName: String
    
    var repeatAfter: Int
    var stopAfter: Int
    
    var isEnabled: Bool = true
}


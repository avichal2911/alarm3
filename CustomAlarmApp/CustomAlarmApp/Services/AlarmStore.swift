import Foundation

class AlarmStore: ObservableObject {
    @Published var alarms: [Alarm] = [] {
        didSet {
            save()
        }
    }
    
    private let key = "saved_alarms"
    
    init() {
        load()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Alarm].self, from: data) {
            alarms = decoded
        }
    }
    
    func add(_ alarm: Alarm) {
        alarms.append(alarm)
        NotificationManager.shared.scheduleNotification(for: alarm)
    }
    
    func update(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            NotificationManager.shared.scheduleNotification(for: alarm)
        }
    }
    
    func toggle(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].isEnabled.toggle()
            if alarms[index].isEnabled {
                NotificationManager.shared.scheduleNotification(for: alarms[index])
            } else {
                NotificationManager.shared.cancelNotification(for: alarm)
            }
        }
    }
}

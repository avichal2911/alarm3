import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    func scheduleNotification(for alarm: Alarm) {
        guard alarm.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = alarm.description
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(alarm.soundName).mp3"))
        content.userInfo = ["alarmID": alarm.id.uuidString]
        
        let triggerDate = computeNextTriggerDate(for: alarm)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarm.id.uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }
    
    func scheduleSnooze(for alarm: Alarm, seconds: Int) {
        let content = UNMutableNotificationContent()
        content.title = alarm.description
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(alarm.soundName).mp3"))
        content.userInfo = ["alarmID": alarm.id.uuidString]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func computeNextTriggerDate(for alarm: Alarm) -> Date {
        var components = DateComponents()
        
        let hour24 = alarm.isAM ? alarm.hour % 12 : (alarm.hour % 12) + 12
        components.hour = hour24
        components.minute = alarm.minute
        
        let calendar = Calendar.current
        let now = Date()
        
        if alarm.mode == .oneTime, let date = alarm.date {
            components.year = calendar.component(.year, from: date)
            components.month = calendar.component(.month, from: date)
            components.day = calendar.component(.day, from: date)
            return calendar.date(from: components) ?? now
        }
        
        if alarm.mode == .weekly, let days = alarm.daysOfWeek {
            for i in 0..<7 {
                let future = calendar.date(byAdding: .day, value: i, to: now)!
                let weekday = calendar.component(.weekday, from: future)
                if days.contains(weekday) {
                    components.year = calendar.component(.year, from: future)
                    components.month = calendar.component(.month, from: future)
                    components.day = calendar.component(.day, from: future)
                    
                    let date = calendar.date(from: components)!
                    if date > now {
                        return date
                    }
                }
            }
        }
        
        return now.addingTimeInterval(60)
    }
}

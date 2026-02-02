import SwiftUI
import UserNotifications

@main
struct CustomAlarmAppApp: App, UNUserNotificationCenterDelegate {
    @StateObject var alarmStore = AlarmStore()
    @StateObject var engine = AlarmEngine.shared
    
    init() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AlarmListView()
                    .environmentObject(alarmStore)
                
                if let alarm = engine.activeAlarm {
                    RingingView(alarm: alarm)
                }
            }
            .onAppear {
                NotificationManager.shared.requestPermission()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let id = response.notification.request.content.userInfo["alarmID"] as? String,
           let alarm = alarmStore.alarms.first(where: { $0.id.uuidString == id }) {
            
            AlarmEngine.shared.start(alarm: alarm)
        }
        
        completionHandler()
    }
}

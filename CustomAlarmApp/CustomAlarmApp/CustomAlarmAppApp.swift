import SwiftUI

@main
struct CustomAlarmAppApp: App {
    @StateObject var alarmStore = AlarmStore()
    
    var body: some Scene {
        WindowGroup {
            AlarmListView()
                .environmentObject(alarmStore)
                .onAppear {
                    NotificationManager.shared.requestPermission()
                }
        }
    }
}


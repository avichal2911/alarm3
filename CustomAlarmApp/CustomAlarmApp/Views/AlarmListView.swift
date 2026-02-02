import SwiftUI

struct AlarmListView: View {
    @EnvironmentObject var alarmStore: AlarmStore
    @State private var showAdd = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(alarmStore.alarms) { alarm in
                    NavigationLink {
                        EditAlarmView(alarm: alarm)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(timeString(for: alarm))
                                    .font(.largeTitle)
                                Text(alarm.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Next: \(nextRingString(for: alarm))")
                                    .font(.caption)
                            }
                            Spacer()
                            Toggle("", isOn: Binding(
                                get: { alarm.isEnabled },
                                set: { _ in alarmStore.toggle(alarm) }
                            ))
                            .labelsHidden()
                        }
                    }
                }
            }
            .navigationTitle("Alarms")
            .toolbar {
                Button("+") {
                    showAdd = true
                }
            }
            .sheet(isPresented: $showAdd) {
                EditAlarmView(alarm: nil)
            }
        }
    }
    
    func timeString(for alarm: Alarm) -> String {
        let hour = alarm.hour
        let minute = String(format: "%02d", alarm.minute)
        let ampm = alarm.isAM ? "AM" : "PM"
        return "\(hour):\(minute) \(ampm)"
    }
    
    func nextRingString(for alarm: Alarm) -> String {
        let date = NotificationManager.shared.computeNextTriggerDate(for: alarm)
        return date.formatted(date: .abbreviated, time: .shortened)
    }
}


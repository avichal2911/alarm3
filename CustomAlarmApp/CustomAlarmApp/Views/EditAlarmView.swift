import SwiftUI

struct EditAlarmView: View {
    @EnvironmentObject var alarmStore: AlarmStore
    @Environment(\.dismiss) var dismiss
    
    @State var alarm: Alarm?
    
    @State private var hour = 6
    @State private var minute = 0
    @State private var isAM = true
    @State private var mode: AlarmMode = .weekly
    @State private var date = Date()
    @State private var days: Set<Int> = []
    @State private var description = ""
    @State private var repeatAfter = 60
    @State private var stopAfter = 30
    
    let weekDays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    
    var body: some View {
        Form {
            Section("Time") {
                Stepper("Hour: \(hour)", value: $hour, in: 1...12)
                Stepper("Minute: \(minute)", value: $minute, in: 0...59)
                Toggle("AM", isOn: $isAM)
            }
            
            Section("Mode") {
                Picker("Mode", selection: $mode) {
                    Text("One Time").tag(AlarmMode.oneTime)
                    Text("Weekly").tag(AlarmMode.weekly)
                }
                .pickerStyle(.segmented)
                
                if mode == .oneTime {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                if mode == .weekly {
                    ForEach(0..<7) { i in
                        Button(weekDays[i]) {
                            if days.contains(i+1) {
                                days.remove(i+1)
                            } else {
                                days.insert(i+1)
                            }
                        }
                    }
                }
            }
            
            Section("Details") {
                TextField("Description", text: $description)
                
                Picker("Repeat After", selection: $repeatAfter) {
                    Text("1 min").tag(60)
                    Text("5 min").tag(300)
                    Text("10 min").tag(600)
                }
                
                Picker("Stop After", selection: $stopAfter) {
                    Text("30 sec").tag(30)
                    Text("60 sec").tag(60)
                }
            }
            
            Button("Save") {
                saveAlarm()
                dismiss()
            }
        }
        .onAppear {
            if let alarm = alarm {
                hour = alarm.hour
                minute = alarm.minute
                isAM = alarm.isAM
                mode = alarm.mode
                date = alarm.date ?? Date()
                days = Set(alarm.daysOfWeek ?? [])
                description = alarm.description
                repeatAfter = alarm.repeatAfter
                stopAfter = alarm.stopAfter
            }
        }
    }
    
    func saveAlarm() {
        let newAlarm = Alarm(
            hour: hour,
            minute: minute,
            isAM: isAM,
            mode: mode,
            date: mode == .oneTime ? date : nil,
            daysOfWeek: mode == .weekly ? Array(days) : nil,
            description: description,
            soundName: "alarm",
            repeatAfter: repeatAfter,
            stopAfter: stopAfter
        )
        
        alarmStore.add(newAlarm)
    }
}


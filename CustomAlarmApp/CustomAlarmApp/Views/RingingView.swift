HStack(spacing: 30) {
    Button("Turn Off") {
        AlarmEngine.shared.turnOff()
    }
    
    Button("Mute") {
        AlarmEngine.shared.mute()
    }
    
    Button("Repeat") {
        AlarmEngine.shared.repeatAlarm()
    }
}

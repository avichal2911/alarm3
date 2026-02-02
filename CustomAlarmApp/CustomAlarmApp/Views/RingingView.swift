import SwiftUI

struct RingingView: View {
    var alarm: Alarm
    
    var body: some View {
        VStack(spacing: 40) {
            Text(timeString())
                .font(.system(size: 60, weight: .bold))
            
            Text(alarm.description)
                .font(.title2)
            
            HStack(spacing: 30) {
                Button("Turn Off") {
                    // logic added later
                }
                
                Button("Mute") {
                    // logic added later
                }
                
                Button("Repeat") {
                    // logic added later
                }
            }
            .font(.title2)
        }
    }
    
    func timeString() -> String {
        let minute = String(format: "%02d", alarm.minute)
        return "\(alarm.hour):\(minute) \(alarm.isAM ? "AM" : "PM")"
    }
}


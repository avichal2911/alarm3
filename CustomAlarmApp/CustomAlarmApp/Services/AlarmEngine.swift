import Foundation
import AVFoundation

class AlarmEngine: ObservableObject {
    static let shared = AlarmEngine()
    
    @Published var activeAlarm: Alarm?
    
    private var player: AVAudioPlayer?
    private var stopTimer: Timer?
    
    func start(alarm: Alarm) {
        activeAlarm = alarm
        playSound(named: alarm.soundName)
        
        stopTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(alarm.stopAfter), repeats: false) { _ in
            self.stopAndScheduleNext()
        }
    }
    
    func turnOff() {
        stopSound()
        scheduleNext()
        activeAlarm = nil
    }
    
    func mute() {
        stopSound()
    }
    
    func repeatAlarm() {
        guard let alarm = activeAlarm else { return }
        stopSound()
        
        NotificationManager.shared.scheduleSnooze(for: alarm, seconds: alarm.repeatAfter)
        activeAlarm = nil
    }
    
    private func stopAndScheduleNext() {
        stopSound()
        scheduleNext()
        activeAlarm = nil
    }
    
    private func scheduleNext() {
        guard let alarm = activeAlarm else { return }
        NotificationManager.shared.scheduleNotification(for: alarm)
    }
    
    private func playSound(named: String) {
        guard let url = Bundle.main.url(forResource: named, withExtension: "mp3") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.play()
    }
    
    private func stopSound() {
        player?.stop()
        stopTimer?.invalidate()
    }
}


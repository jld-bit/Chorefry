import Foundation
import UserNotifications

@MainActor
final class ReminderNotificationManager: ObservableObject {
    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    func requestAuthorization() async {
        do {
            let center = UNUserNotificationCenter.current()
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            authorizationStatus = granted ? .authorized : .denied
        } catch {
            print("Notification authorization failed: \(error)")
        }
    }

    func scheduleOverdueReminder(for chore: ChoreItem) async {
        guard chore.dueDate < .now, !chore.isCompleted else { return }

        let content = UNMutableNotificationContent()
        content.title = "Chore reminder"
        content.body = "\(chore.title) is overdue. Jump back into ChoreBloom to keep your streak alive!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "overdue-\(chore.persistentModelID)", content: content, trigger: trigger)

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule reminder: \(error)")
        }
    }
}

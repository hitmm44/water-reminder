import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleNotifications(settings: AppSettings) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        guard settings.notificationsEnabled else { return }

        let messages = [
            "Время пить воду! 💧",
            "Не забудь выпить стакан воды 🌊",
            "Поддержи водный баланс! 💦",
            "Твоё тело просит воды! 🥤",
            "Сделай глоток прямо сейчас! 💙"
        ]

        var hour = settings.reminderStartHour
        var index = 0

        while hour < settings.reminderEndHour {
            var components = DateComponents()
            components.hour = hour
            components.minute = 0

            let content = UNMutableNotificationContent()
            content.title = "Выпей воду"
            content.body = messages[index % messages.count]
            content.sound = .default
            content.badge = 1

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(
                identifier: "water_reminder_\(hour)",
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)

            hour += settings.reminderIntervalHours
            index += 1
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

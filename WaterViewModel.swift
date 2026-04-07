import Foundation
import SwiftUI

class WaterViewModel: ObservableObject {
    @Published var entries: [WaterEntry] = []
    @Published var settings: AppSettings = AppSettings()

    private let entriesKey = "water_entries_v1"
    private let settingsKey = "water_settings_v1"

    init() {
        loadEntries()
        loadSettings()
        // Запланировать уведомления при старте
        if settings.notificationsEnabled {
            NotificationManager.shared.requestPermission { granted in
                if granted {
                    NotificationManager.shared.scheduleNotifications(settings: self.settings)
                }
            }
        }
    }

    // MARK: - Данные за сегодня

    var todayEntries: [WaterEntry] {
        let calendar = Calendar.current
        return entries
            .filter { calendar.isDateInToday($0.date) }
            .sorted { $0.date > $1.date }
    }

    var todayTotalML: Int {
        todayEntries.reduce(0) { $0 + $1.amount }
    }

    var todayProgress: Double {
        min(Double(todayTotalML) / Double(settings.dailyGoalML), 1.0)
    }

    var todayGlasses: Int {
        todayEntries.count
    }

    var remainingML: Int {
        max(settings.dailyGoalML - todayTotalML, 0)
    }

    var goalReached: Bool {
        todayTotalML >= settings.dailyGoalML
    }

    // MARK: - Действия

    func addWater() {
        let entry = WaterEntry(amount: settings.glassSizeML)
        entries.append(entry)
        saveEntries()
    }

    func removeEntry(_ entry: WaterEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }

    func removeLastEntry() {
        guard let last = todayEntries.first else { return }
        removeEntry(last)
    }

    // MARK: - Статистика

    func weeklyData() -> [(date: Date, ml: Int)] {
        let calendar = Calendar.current
        let today = Date()

        return (0..<7).reversed().map { daysAgo in
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: today)!
            let dayStart = calendar.startOfDay(for: date)
            let dayEntries = entries.filter { calendar.isDate($0.date, inSameDayAs: dayStart) }
            return (date: dayStart, ml: dayEntries.reduce(0) { $0 + $1.amount })
        }
    }

    func totalDaysWithGoal() -> Int {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.date) }
        return grouped.filter { $0.value.reduce(0) { $0 + $1.amount } >= settings.dailyGoalML }.count
    }

    func totalWaterConsumed() -> Int {
        entries.reduce(0) { $0 + $1.amount }
    }

    func averageDailyML() -> Int {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.date) }
        guard !grouped.isEmpty else { return 0 }
        let total = grouped.values.reduce(0) { $0 + $1.reduce(0) { $0 + $1.amount } }
        return total / grouped.count
    }

    // MARK: - Настройки

    func updateSettings(_ newSettings: AppSettings) {
        settings = newSettings
        saveSettings()
        if newSettings.notificationsEnabled {
            NotificationManager.shared.requestPermission { granted in
                if granted {
                    NotificationManager.shared.scheduleNotifications(settings: newSettings)
                }
            }
        } else {
            NotificationManager.shared.cancelAllNotifications()
        }
    }

    // MARK: - Сохранение

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: entriesKey)
        }
    }

    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: entriesKey),
              let decoded = try? JSONDecoder().decode([WaterEntry].self, from: data) else { return }
        entries = decoded
    }

    private func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }

    private func loadSettings() {
        guard let data = UserDefaults.standard.data(forKey: settingsKey),
              let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) else { return }
        settings = decoded
    }
}

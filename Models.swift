import Foundation

// MARK: - Water Entry

struct WaterEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let amount: Int // мл

    init(id: UUID = UUID(), date: Date = Date(), amount: Int) {
        self.id = id
        self.date = date
        self.amount = amount
    }
}

// MARK: - App Settings

struct AppSettings: Codable {
    var dailyGoalML: Int = 2000
    var glassSizeML: Int = 250
    var reminderIntervalHours: Int = 2
    var reminderStartHour: Int = 8
    var reminderEndHour: Int = 22
    var notificationsEnabled: Bool = true
}

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: WaterViewModel
    @State private var settings: AppSettings = AppSettings()
    @State private var showingSaved = false
    @State private var showingResetConfirm = false

    var body: some View {
        NavigationView {
            Form {
                // Потребление воды
                Section(header: Text("Потребление воды")) {
                    HStack {
                        Label("Дневная цель", systemImage: "target")
                        Spacer()
                        Stepper(
                            "\(settings.dailyGoalML) мл",
                            value: $settings.dailyGoalML,
                            in: 500...5000,
                            step: 250
                        )
                    }

                    HStack {
                        Label("Объём стакана", systemImage: "cup.and.saucer.fill")
                        Spacer()
                        Stepper(
                            "\(settings.glassSizeML) мл",
                            value: $settings.glassSizeML,
                            in: 100...500,
                            step: 50
                        )
                    }
                }

                // Напоминания
                Section(header: Text("Напоминания")) {
                    Toggle(isOn: $settings.notificationsEnabled) {
                        Label("Включить напоминания", systemImage: "bell.fill")
                    }

                    if settings.notificationsEnabled {
                        HStack {
                            Label("Интервал", systemImage: "clock")
                            Spacer()
                            Stepper(
                                "каждые \(settings.reminderIntervalHours) ч",
                                value: $settings.reminderIntervalHours,
                                in: 1...6
                            )
                        }

                        HStack {
                            Label("С", systemImage: "sunrise")
                            Spacer()
                            Stepper(
                                "\(settings.reminderStartHour):00",
                                value: $settings.reminderStartHour,
                                in: 5...12
                            )
                        }

                        HStack {
                            Label("До", systemImage: "sunset")
                            Spacer()
                            Stepper(
                                "\(settings.reminderEndHour):00",
                                value: $settings.reminderEndHour,
                                in: 18...23
                            )
                        }
                    }
                }

                // Сохранить
                Section {
                    Button(action: {
                        viewModel.updateSettings(settings)
                        showingSaved = true
                        let feedback = UINotificationFeedbackGenerator()
                        feedback.notificationOccurred(.success)
                    }) {
                        HStack {
                            Spacer()
                            Label("Сохранить настройки", systemImage: "checkmark")
                                .foregroundColor(.blue)
                            Spacer()
                        }
                    }
                }

                // Сброс данных
                Section {
                    Button(role: .destructive) {
                        showingResetConfirm = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("Сбросить все данные", systemImage: "trash")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Настройки ⚙️")
            .onAppear {
                settings = viewModel.settings
            }
            .alert("Сохранено!", isPresented: $showingSaved) {
                Button("OK") {}
            } message: {
                Text("Настройки обновлены. Уведомления перепланированы.")
            }
            .alert("Сбросить данные?", isPresented: $showingResetConfirm) {
                Button("Сбросить", role: .destructive) {
                    viewModel.entries.removeAll()
                    UserDefaults.standard.removeObject(forKey: "water_entries_v1")
                }
                Button("Отмена", role: .cancel) {}
            } message: {
                Text("Все записи о выпитой воде будут удалены. Это действие нельзя отменить.")
            }
        }
    }
}

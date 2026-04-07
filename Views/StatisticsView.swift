import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var viewModel: WaterViewModel

    var weeklyData: [(date: Date, ml: Int)] {
        viewModel.weeklyData()
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Недельный график
                    VStack(alignment: .leading, spacing: 12) {
                        Text("За 7 дней")
                            .font(.headline)
                            .padding(.horizontal)

                        Chart(weeklyData, id: \.date) { item in
                            BarMark(
                                x: .value("День", item.date, unit: .day),
                                y: .value("мл", item.ml)
                            )
                            .foregroundStyle(
                                item.ml >= viewModel.settings.dailyGoalML
                                    ? Color.blue
                                    : Color.blue.opacity(0.35)
                            )
                            .cornerRadius(6)

                            RuleMark(y: .value("Цель", viewModel.settings.dailyGoalML))
                                .foregroundStyle(.orange)
                                .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5]))
                                .annotation(position: .top, alignment: .trailing) {
                                    Text("Цель")
                                        .font(.caption2)
                                        .foregroundColor(.orange)
                                }
                        }
                        .frame(height: 200)
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { _ in
                                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Сводная статистика
                    VStack(spacing: 0) {
                        StatRow(
                            title: "Всего выпито",
                            value: formatML(viewModel.totalWaterConsumed()),
                            icon: "drop.fill",
                            color: .blue
                        )
                        Divider().padding(.leading, 44)

                        StatRow(
                            title: "Среднее в день",
                            value: formatML(viewModel.averageDailyML()),
                            icon: "chart.line.uptrend.xyaxis",
                            color: .cyan
                        )
                        Divider().padding(.leading, 44)

                        StatRow(
                            title: "Дней с выполненной целью",
                            value: "\(viewModel.totalDaysWithGoal())",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        Divider().padding(.leading, 44)

                        StatRow(
                            title: "Дневная цель",
                            value: "\(viewModel.settings.dailyGoalML) мл",
                            icon: "target",
                            color: .orange
                        )
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Статистика 📊")
        }
    }

    private func formatML(_ ml: Int) -> String {
        if ml >= 1000 {
            return String(format: "%.1f л", Double(ml) / 1000.0)
        }
        return "\(ml) мл"
    }
}

// MARK: - Строка статистики

struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 10)
    }
}

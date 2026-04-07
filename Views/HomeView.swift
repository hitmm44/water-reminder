import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WaterViewModel
    @State private var showConfetti = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // Прогресс-круг
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.15), lineWidth: 22)

                        Circle()
                            .trim(from: 0, to: viewModel.todayProgress)
                            .stroke(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 22, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.5), value: viewModel.todayProgress)

                        VStack(spacing: 6) {
                            Text("\(viewModel.todayTotalML)")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                            Text("из \(viewModel.settings.dailyGoalML) мл")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(viewModel.todayGlasses) стак.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 230, height: 230)
                    .padding(.top, 16)

                    // Цель достигнута
                    if viewModel.goalReached {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                            Text("Дневная цель достигнута!")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.green.opacity(0.12))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // Карточки
                    HStack(spacing: 14) {
                        InfoCard(
                            title: "Выпито",
                            value: "\(viewModel.todayTotalML) мл",
                            icon: "drop.fill",
                            color: .blue
                        )
                        InfoCard(
                            title: "Осталось",
                            value: "\(viewModel.remainingML) мл",
                            icon: "target",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)

                    // Кнопка "Выпил стакан"
                    Button(action: {
                        viewModel.addWater()
                        let feedback = UIImpactFeedbackGenerator(style: .medium)
                        feedback.impactOccurred()
                    }) {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                            Text("Выпил стакан (\(viewModel.settings.glassSizeML) мл)")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)

                    // Журнал за сегодня
                    if !viewModel.todayEntries.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Сегодня")
                                    .font(.headline)
                                Spacer()
                                Button("Отменить последний") {
                                    let feedback = UINotificationFeedbackGenerator()
                                    feedback.notificationOccurred(.warning)
                                    viewModel.removeLastEntry()
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }

                            ForEach(viewModel.todayEntries) { entry in
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 20)
                                    Text("\(entry.amount) мл")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(entry.date, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Вода 💧")
        }
    }
}

// MARK: - Карточка

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

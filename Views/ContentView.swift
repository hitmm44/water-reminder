import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WaterViewModel

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "drop.fill")
                }

            StatisticsView()
                .tabItem {
                    Label("Статистика", systemImage: "chart.bar.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape.fill")
                }
        }
        .tint(.blue)
    }
}

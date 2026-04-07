import SwiftUI

@main
struct WaterReminderApp: App {
    @StateObject private var viewModel = WaterViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

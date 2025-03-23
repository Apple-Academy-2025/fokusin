import SwiftUI
import SwiftData

@main
struct fokusinApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([PomodoroSession.self])  // Sesuaikan dengan model data
        let container = try! ModelContainer(for: schema)
        return container
    }()

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .modelContainer(sharedModelContainer) 
        }
    }
}

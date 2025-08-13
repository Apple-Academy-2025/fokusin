//
//  fokusinApp.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//

import SwiftUI
import SwiftData

@main
struct fokusinApp: App {
    let container: ModelContainer

    init() {
        do {
            // Put ALL your models here
            let schema = Schema([PomodoroSession.self, AppSettings.self])
            container = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .modelContainer(container)
        }
    }
}


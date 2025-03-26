//
//  DataViewModel.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 19/03/25.
//

import Foundation

class DifficultyViewModel: ObservableObject {
    @Published var modes: [DifficultyMode] = [
        DifficultyMode(
            id: 1,
            difficulty: "Short",
            title: "SHORT MODE",
            description: "This Pomodoro Short Mode Session is perfect for simple tasks such as : ",
            time: (focus: 15 * 60, rest: 3 * 60, section: 1),
            detail: ["Reading Book", "Journaling","Organizing Files","Recording Daily Finances"]
        ),
        DifficultyMode(
            id: 2,
            difficulty: "Reguler",
            title: "REGULAR MODE",
            description: "This pomodoro regular mode session is ideal for tasks that require more concentration such as : ",
            time: (focus: 30 * 60, rest: 5 * 60, section: 1),
            detail: ["Writing Reports", "Reading Books", "Reviewing Materials", "Completing Assignments"]
        ),
        DifficultyMode(
            id: 3,
            difficulty: "Long",
            title: "LONG MODE",
            description: "This pomodoro long mode session is perfect for complex tasks such as:",
            time: (focus: 60 * 60, rest: 10 * 60, section: 2),
            detail: ["Coding", "Conducting Research", "Writing Code", "Designing UI/UX"]
        ),
        
        DifficultyMode(
            id: 4,
            difficulty: "Custom",
            title: "CUSTOM MODE",
            description: "The pomodoro custom mode session gives you the flexibility to set your work and break durations based on task difficulty, your physical condition, and personal preferences.",
            time: (focus: 0, rest: 0, section: 0),
            detail: []
        )
    ]
    
    /// Fungsi untuk mendapatkan mode berdasarkan `difficulty`
    func getMode(by difficulty: String) -> DifficultyMode? {
        return modes.first { $0.difficulty == difficulty }
    }
}





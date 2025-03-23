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
            difficulty: "Easy",
            title: "Mode Easy",
            description: "Mode easy: 15 menit fokus dengan 5 menit istirahat.",
            time: (focus: 15 * 60, rest: 5 * 60, section: 2),
            detail: ["Baca buku", "Baca jurnal"]
        ),
        DifficultyMode(
            id: 2,
            difficulty: "Medium",
            title: "Mode Medium",
            description: "Mode medium: 25 menit fokus dengan 5 menit istirahat.",
            time: (focus: 25 * 60, rest: 5 * 60, section: 3),
            detail: ["Belajar coding", "Review materi"]
        ),
        DifficultyMode(
            id: 3,
            difficulty: "Hard",
            title: "Mode Hard",
            description: "Mode hard: 45 menit fokus dengan 15 menit istirahat.",
            time: (focus: 45 * 60, rest: 15 * 60, section: 4),
            detail: ["Mengerjakan proyek", "Membaca jurnal ilmiah"]
        ),
        
        DifficultyMode(
            id: 4,
            difficulty: "Custom",
            title: "Mode Custom",
            description: "Mode hard: 45 menit fokus dengan 15 menit istirahat.",
            time: (focus: 0, rest: 0, section: 0),
            detail: ["Mengerjakan proyek", "Membaca jurnal ilmiah"]
        )
    ]
    
    /// Fungsi untuk mendapatkan mode berdasarkan `difficulty`
    func getMode(by difficulty: String) -> DifficultyMode? {
        return modes.first { $0.difficulty == difficulty }
    }
}





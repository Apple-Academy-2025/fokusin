//
//  PomodoroSessionModel.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 23/03/25.
//

import Foundation
import SwiftData

enum Difficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case custom = "Custom"
}

@Model
class PomodoroSession {
    var id: UUID = UUID() // Tidak perlu anotasi khusus
    var difficulty: Difficulty
    var timeFocus: Int
    var session: Int
    var totalFocus: Int
    var status: Bool

    init(difficulty: Difficulty, timeFocus: Int, session: Int, totalFocus: Int, status: Bool) {
        self.difficulty = difficulty
        self.timeFocus = timeFocus
        self.session = session
        self.totalFocus = totalFocus
        self.status = status
    }
}



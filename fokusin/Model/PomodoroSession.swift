//
//  PomodoroSessionModel.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 23/03/25.
//

import Foundation
import SwiftData

enum Difficulty: String, Codable {
    case easy = "Short"
    case medium = "Reguler"
    case hard = "Long"
    case custom = "Custom"
}

@Model
class PomodoroSession {
    var id: UUID = UUID()
    var difficulty: Difficulty
    var timeFocus: Int
    var session: Int
    var totalFocus: Int
    var status: Bool
    var date: Date

    init(difficulty: Difficulty, timeFocus: Int, session: Int, totalFocus: Int, status: Bool, date: Date = Date()) {
        self.difficulty = difficulty
        self.timeFocus = timeFocus
        self.session = session
        self.totalFocus = totalFocus
        self.status = status
        self.date = date
    }
}



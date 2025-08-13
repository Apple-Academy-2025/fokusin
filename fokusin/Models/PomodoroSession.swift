//
//  PomodoroSession.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 11/08/25.
//


import Foundation
import SwiftData

@Model
final class PomodoroSession {
    @Attribute(.unique) var id: UUID
    var date: Date                 // waktu selesai sesi
    var modeTitle: String          // "Mode Pendek", "Mode Kustom", dll
    var cycles: Int
    var focusSeconds: Int
    var breakSeconds: Int
    var completed: Bool            // true kalau finish normal

    init(date: Date = Date(),
         modeTitle: String,
         cycles: Int,
         focusSeconds: Int,
         breakSeconds: Int,
         completed: Bool) {
        self.id = UUID()
        self.date = date
        self.modeTitle = modeTitle
        self.cycles = cycles
        self.focusSeconds = focusSeconds
        self.breakSeconds = breakSeconds
        self.completed = completed
    }
}

@MainActor
struct PomodoroStore {
    let ctx: ModelContext

    func addSession(modeTitle: String,
                    cycles: Int,
                    focusSeconds: Int,
                    breakSeconds: Int,
                    completed: Bool = true) throws {
        ctx.insert(PomodoroSession(
            modeTitle: modeTitle,
            cycles: cycles,
            focusSeconds: focusSeconds,
            breakSeconds: breakSeconds,
            completed: completed
        ))
        try ctx.save()
    }

    func totalFocusMinutesAllTime() throws -> Int {
        let sessions = try ctx.fetch(FetchDescriptor<PomodoroSession>())
        return sessions.reduce(0) { $0 + $1.focusSeconds } / 60
    }

    func totalFocusMinutes(on day: Date) throws -> Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: day)
        let end   = cal.date(byAdding: .day, value: 1, to: start)!
        let p = #Predicate<PomodoroSession> { $0.date >= start && $0.date < end }
        let fd = FetchDescriptor<PomodoroSession>(predicate: p)
        let sessions = try ctx.fetch(fd)
        return sessions.reduce(0) { $0 + $1.focusSeconds } / 60
    }
}

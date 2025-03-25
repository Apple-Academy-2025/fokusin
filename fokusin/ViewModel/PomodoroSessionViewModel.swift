//
//  PomodoroSessionViewModel.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 23/03/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class PomodoroSessionViewModel {
    private var modelContext: ModelContext
    
    var sessions: [PomodoroSession] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchSessions()
    }
    
    /// Ambil semua sesi dari database
    func fetchSessions() {
        do {
            let descriptor = FetchDescriptor<PomodoroSession>(sortBy: [SortDescriptor(\.totalFocus, order: .reverse)])
            self.sessions = try modelContext.fetch(descriptor)
        } catch {
            print("⚠️ Error fetching sessions: \(error.localizedDescription)")
        }
    }
    
    /// Tambah sesi baru
    func addSession(difficulty: Difficulty, timeFocus: Int, session: Int, totalFocus: Int, status: Bool) {
        let newSession = PomodoroSession(difficulty: difficulty, timeFocus: timeFocus, session: session, totalFocus: totalFocus, status: status)
        
        modelContext.insert(newSession)
        save()
    }
    
    /// Hapus sesi
    func deleteSession(_ session: PomodoroSession) {
        modelContext.delete(session)
        save()
    }
    
    /// Update sesi (misal, ubah status menjadi selesai)
    func updateSession(_ session: PomodoroSession, status: Bool) {
        session.status = status
        save()
    }
    
    func totalBerhasilHariIni() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions.filter { $0.status && Calendar.current.isDate($0.date, inSameDayAs: today) }.count
    }
    
    /// Simpan perubahan ke database
    private func save() {
        do {
            try modelContext.save()
            fetchSessions() // Refresh data setelah perubahan
        } catch {
            print("⚠️ Error saving session: \(error.localizedDescription)")
        }
    }
}

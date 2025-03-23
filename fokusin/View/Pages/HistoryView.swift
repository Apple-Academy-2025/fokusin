//
//  HistoryView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 23/03/25.
//

import SwiftUI
import SwiftData  // Pastikan SwiftData di-import

struct HistoryView: View {
    @Query var sessions: [PomodoroSession]  // Ambil semua data PomodoroSession

    var body: some View {
        NavigationView {
            List {
                ForEach(sessions) { session in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("🔥 \(session.difficulty.rawValue) Mode")
                            .font(.headline)
                            .foregroundColor(.blue)

                        Text("⏳ Fokus: \(session.timeFocus) menit x \(session.session) sesi")
                            .font(.subheadline)

                        Text("📊 Total Waktu: \(session.totalFocus) menit")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text(session.status ? "✅ Selesai" : "❌ Dibatalkan")
                            .font(.subheadline)
                            .foregroundColor(session.status ? .green : .red)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    HistoryView()
}


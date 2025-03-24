//
//  HistoryView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 23/03/25.
//

import SwiftUI
import SwiftData  // Pastikan SwiftData di-import
import Lottie

struct HistoryView: View {
    @Query var sessions: [PomodoroSession]  // Ambil semua data PomodoroSession

    var body: some View {
        NavigationView {
            List {
                if sessions.isEmpty {
                    Section {
                        VStack {
                            LottieView(animation: .named("EmpetyEgg"))
                                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                                .frame(width: 300, height: 250)  // 🔹 Sesuaikan ukuran
                            
                            Text("Kamu masih belum ada riwayat")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    ForEach(sessions) { session in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("🔥 \(session.difficulty.rawValue) Mode")
                                .font(.headline)
                                .foregroundColor(.blue)

                            Text("⏳ Fokus: \(formatTime(session.timeFocus)) x \(session.session) sesi")
                                .font(.subheadline)

                            Text("📊 Total Waktu: \(session.totalFocus / 60) menit")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text(session.status ? "✅ Selesai" : "❌ Dibatalkan")
                                .font(.subheadline)
                                .foregroundColor(session.status ? .green : .red)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("History")
        }
    }

    // Fungsi untuk format waktu dalam menit & detik
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60

        if minutes == 0 {
            return "\(remainingSeconds) detik"
        } else if remainingSeconds == 0 {
            return "\(minutes) menit"
        } else {
            return "\(minutes) menit \(remainingSeconds) detik"
        }
    }
}

#Preview {
    HistoryView()
}




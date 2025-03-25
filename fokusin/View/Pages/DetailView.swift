import SwiftUI
import SwiftData  // Pastikan SwiftData di-import
import Lottie

struct DetailView: View {
    @Query var sessions: [PomodoroSession]  // Ambil semua data PomodoroSession

    var body: some View {
        NavigationView {
            VStack {
                // 📊 Ringkasan Statistik
                summaryView()

                List {
                    if sessions.isEmpty {
                        emptyStateView()
                    } else {
                        // 🔹 Kelompokkan berdasarkan mode
                        let groupedSessions = Dictionary(grouping: sessions, by: { $0.difficulty })
                        
                        ForEach(groupedSessions.keys.sorted { $0.rawValue < $1.rawValue }, id: \.self) { mode in
                            if let modeSessions = groupedSessions[mode] {
                                Section(header: Text("🔥 \(mode.rawValue) Mode").font(.headline)) {
                                    ForEach(modeSessions) { session in
                                        sessionCard(session: session)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }

    // MARK: - UI Komponen
    @ViewBuilder
    func summaryView() -> some View {
        VStack {
            HStack {
                summaryItem(title: "✅ Berhasil", value: "\(totalBerhasil()) sesi")
                summaryItem(title: "❌ Gagal", value: "\(totalGagal()) sesi")
            }

            HStack {
                summaryItem(title: "⏳ Total Waktu", value: "\(totalWaktuBerhasil() / 60) menit")
                summaryItem(title: "📆 Hari Ini", value: "\(totalWaktuHariIni() / 60) menit")
            }
        }
        .padding()
    }

    @ViewBuilder
    func summaryItem(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    func emptyStateView() -> some View {
        VStack {
            LottieView(animation: .named("eggNest"))
                .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                .frame(width: 300, height: 250)
            
            Text("Kamu masih belum ada riwayat")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    func sessionCard(session: PomodoroSession) -> some View {
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

    // MARK: - LOGIC: Statistik Perhitungan

    /// 🔹 Menghitung total sesi yang berhasil
    func totalBerhasil() -> Int {
        return sessions.filter { $0.status }.count
    }

    /// 🔹 Menghitung total sesi yang gagal
    func totalGagal() -> Int {
        return sessions.filter { !$0.status }.count
    }

    /// 🔹 Menghitung total waktu dari sesi yang berhasil (dalam detik)
    func totalWaktuBerhasil() -> Int {
        return sessions.filter { $0.status }.reduce(0) { $0 + $1.totalFocus }
    }

    /// 🔹 Menghitung total waktu berhasil **hanya untuk hari ini**
    func totalWaktuHariIni() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions
            .filter { $0.status && Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.totalFocus }
    }

    // MARK: - Helper: Format Waktu
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
    DetailView()
}

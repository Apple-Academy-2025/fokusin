import SwiftUI
import Lottie
import SwiftData

struct HistoryView: View {
    @StateObject private var viewModel = DifficultyViewModel()
    @Query var sessions: [PomodoroSession]  // Ambil semua data PomodoroSession
    //    let difficulty: String
    
    @State private var isShaking = false
    @State private var progress: CGFloat = 0.0 // Progress bar percentage (0.0 - 1.0)
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.primer.edgesIgnoringSafeArea(.all)
            VStack{
                //                heading
                VStack() {
                    VStack {
                        Ellipse()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 150, height: 20)
                            .offset(y: 160)
                        
                        // 🔥 Animasi Telur Goyang
                        Image(.telurUtuh)
                            .resizable()
                            .frame(
                                width: 30 + (80 * progress),  // 30 ➝ 110 (maks)
                                height: 40 + (90 * progress)  // 40 ➝ 130 (maks)
                            )
                            .padding(.bottom, 5)
                            .rotationEffect(.degrees(isShaking ? 5 : -5))
                            .onAppear {
                                withAnimation(
                                    Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)
                                ) {
                                    isShaking.toggle()
                                }
                            }
                            .padding()
                    }
                    .padding(.top, 40)
                    HStack(spacing: 10) {
                        StatCard(icon: "TelurUtuh", count: totalBerhasil(), label: "Succed", status: true)
                        StatCard(icon: "CrackEgg", count: totalGagal(), label: "Failed", status: false)
                    }
                    
                    
                    
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.primer1)
                .cornerRadius(40)
                .edgesIgnoringSafeArea(.top)
                
                //                body
                VStack(alignment: .center) {
                    // 🔥 Progress Bar Dinamis
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 300, height: 15)
                            .foregroundColor(Color.gray.opacity(0.3))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 300 * progress, height: 15)
                            .foregroundColor(.orange)
                            .animation(.easeInOut(duration: 0.5), value: progress)
                    }.onChange(of: sessions) { oldValue, newValue in
                        print("🔄 onChange: sessions berubah!")
                        print("📝 Sebelumnya: \(oldValue.count) sesi, Sekarang: \(newValue.count) sesi")
                        
                        DispatchQueue.main.async {
                            updateProgress()
                        }
                    }
                    Text("Reach \(remainingMinutes()) minutes left for your egg evolution!")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                        .onAppear {
                            print("✅ onAppear: Memanggil updateProgress()")
                            updateProgress()
                        }
                    
                    
                    
                    
                    HStack(spacing: 10) {
                        TotalTimeCard(icon: "clock", count: totalWaktuBerhasilFormatted(), label: "Time Total", status: true)
                        TotalTimeCard(icon: "target", count: totalWaktuHariIniFormatted(), label: "Today", status: false)
                    }.padding(.bottom,5)
                    
//                    NavigationLink(destination: DetailView()) {
//                        Text("Click Me")
//                            .padding(.horizontal, 12)
//                            .padding(.vertical,5)
//                            .background(.tombol)
//                            .foregroundColor(.tombol2)
//                            .cornerRadius(23)
//                            .fontWeight(.semibold)
//                            
//                            
//                    }
                    
                    // Riwayat
                    VStack {
                        VStack {
                            CardSession(mode: "Mode Short", duration: "15:00 Menit | 2x Sesi", count: countSessions(for: .easy))
                            CardSession(mode: "Mode Reguler", duration: "25:00 Menit | 2x Sesi", count: countSessions(for: .medium))
                            CardSession(mode: "Mode Long", duration: "45:00 Menit | 2x Sesi", count: countSessions(for: .hard))
                            CardSession(mode: "Mode Custom", duration: "xx:xx Menit | x Sesi", count: countSessions(for: .custom))
                            
                            
                            
                            // ⏰ Menampilkan daftar detail aktivitas
                            
                            
                        }
                        .overlay(alignment: .top) {
                            Text( "HISTORY")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.primer)
                                .zIndex(10)
                                .padding(.horizontal, 45)
                                .padding(.vertical, 5)
                                .background(.tombol2)
                                .cornerRadius(10)
                                .offset(y: -20)
                        }
                        .padding(.top,25)
                    }.padding(.bottom,25)
                    
                }
                .padding(.top,-80)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .padding(.horizontal)
            }
            
            
        }
    }
    
    
    // MARK: - count remaining
    /// 🔹 Menghitung jumlah menit yang masih dibutuhkan untuk mencapai 100 menit
    func remainingMinutes() -> Int {
        let totalSeconds = totalWaktuHariIni()
        let maxSeconds = 6000  // 100 menit dalam detik
        let remaining = max(0, maxSeconds - totalSeconds)
        return remaining / 60  // Konversi ke menit
    }
    
    // MARK: - count session
    /// 🔹 Menghitung jumlah sesi berhasil berdasarkan difficulty
    func countSessions(for difficulty: Difficulty) -> Int {
        return sessions.filter { $0.status && $0.difficulty == difficulty }.count
    }
    
    
    
    
    // MARK: - Progress Bar Logic
    func updateProgress() {
        let totalSeconds = totalWaktuHariIni()
        let maxSeconds = 6000  // 100 menit dalam detik
        let calculatedProgress = CGFloat(totalSeconds) / CGFloat(maxSeconds)
        
        
        DispatchQueue.main.async {
            progress = min(calculatedProgress, 1.0)
            print("✅ Progress setelah update: \(progress)")
        }
    }
    
    
    
    // MARK: - Progress Bar Logic
    /// 🔹 Menghitung total waktu berhasil  hanya untuk hari ini  dalam detik
    func totalWaktuHariIni() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return sessions
            .filter { $0.status && Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.totalFocus }
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
    
    /// 🔹 Menghitung total waktu dari sesi yang berhasil (dalam detik), lalu format ke jam:menit
    func totalWaktuBerhasilFormatted() -> String {
        let totalSeconds = sessions.filter { $0.status }.reduce(0) { $0 + $1.totalFocus }
        return formatTime(totalSeconds)
    }
    
    /// 🔹 Menghitung total waktu berhasil **hanya untuk hari ini**, lalu format ke jam:menit
    func totalWaktuHariIniFormatted() -> String {
        let today = Calendar.current.startOfDay(for: Date())
        let totalSeconds = sessions
            .filter { $0.status && Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.totalFocus }
        return formatTime(totalSeconds)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", minutes)
        
        return "\(formattedHours) H: \(formattedMinutes) M"
    }
    
    
}






// 🛠️ Preview
#Preview {
    HistoryView()
}

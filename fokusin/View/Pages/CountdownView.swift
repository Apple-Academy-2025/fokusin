import SwiftUI

struct CountdownView: View {
    let difficulty: String
    let focusTime: Int
    let restTime: Int
    let session: Int
    
    @State var isActive : Bool = false
    
    @State private var timeRemaining: Int
    @State private var sessionCount: Int
    @State private var isFocusTime: Bool = true
    @State private var timerRunning = false
    @State private var timer: Timer?

    @State private var showExitAlert: Bool = false
    @State private var showSessionAlert: Bool = false
    @State private var sessionMessage: String = ""
    @State private var buttonText: String = "Start"

    @Environment(\.presentationMode) var presentationMode // 🔹 Untuk menangani navigasi keluar

    init(difficulty: String, focusTime: Int, restTime: Int, session: Int) {
        self.difficulty = difficulty
        self.focusTime = focusTime
        self.restTime = restTime
        self.session = session
        self._timeRemaining = State(initialValue: focusTime)
        self._sessionCount = State(initialValue: session)
    }

    var body: some View {
        ZStack {
            Color.primer.ignoresSafeArea(.all)
            
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.primer1)
                        .frame(width: 200, height: 200)
                    
                    Text(isFocusTime ? "Focus Time" : "Rest Time")
                        .font(.largeTitle)
                        .padding()
                }
                
                Text("\(formatTime(timeRemaining))")
                    .font(.system(size: 40, weight: .bold))
                    .padding()
                
                HStack(spacing: 20) {
                    Button(action: { handleButtonPress() }) {
                        Text(buttonText)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(buttonText == "Start" ? Color.green : Color.tombol2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .onDisappear {
                stopTimer()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EmptyView() // 🔥 Sembunyikan tombol back
            }
        }

        

        .overlay {
            if showExitAlert {
                CustomAlert(
                    isActive: $showExitAlert,
                    title: "Keluar Nih?!",
                    message: "Kamu yakin akan meninggalkan pomodoro? telur nya nanti pecah",
                    buttonTitle: "Keluar"
                ){
                    exitPomodoro()
                }
            }
            
            if showSessionAlert {
                AlertWithoutButton(
                    isActive: $showSessionAlert,
                    title: "Sesi Berubah",
                    message: sessionMessage
                )
            }
            
//            jika sudah selesai?
        
            
            
        
        }.interactiveDismissDisabled(true)

        .onChange(of: showExitAlert) {
            if showExitAlert {
                stopTimer() // ⏸️ Hentikan timer
            } else {
                resumeTimer() // ▶️ Lanjutkan timer
            }
        }
    }
    
    
    /// Fungsi untuk menghentikan Pomodoro dan kembali ke halaman sebelumnya
    private func exitPomodoro() {
        print("berhasil keluar")
        stopTimer() // 🔥 Hentikan timer agar tidak terus berjalan
        presentationMode.wrappedValue.dismiss() // 🔹 Kembali ke halaman sebelumnya
    }

    
    private func resumeTimer() {
        if !timerRunning {
            startTimer()
        }
    }


    private func handleButtonPress() {
        if buttonText == "Start" {
            startTimer()
            buttonText = "Skip"
        } else {
            stopTimer() // 🔥 Pause sementara, bukan stop total
            showExitAlert = true // 🔹 Jika "Skip" ditekan, tampilkan alert keluar
        }
    }


    private func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                handleSessionEnd()
            }
        }
    }

    private func stopTimer() {
        timerRunning = false
        timer?.invalidate()
    }

    private func handleSessionEnd() {
        if sessionCount > 1 {
            isFocusTime.toggle()
            sessionCount -= 1
            timeRemaining = isFocusTime ? focusTime : restTime
                    
            // 🔥 Menentukan pesan alert untuk pergantian sesi
            if isFocusTime {
                sessionMessage = "Kembali ke sesi fokus! Sisa \(sessionCount) sesi lagi."
                } else {
                    sessionMessage = "Waktunya istirahat! Sisa fokus \(sessionCount) sesi lagi."
                }
                    
                showSessionAlert = true
                    
                // ⏳ Alert hilang setelah 3 detik
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showSessionAlert = false
                    startTimer()
                }
            } else {
                // 🎉 Jika sesi selesai, tampilkan alert selesai
                sessionMessage = "Pomodoro selesai! Kerja bagus! 🎉"
                showSessionAlert = true
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showSessionAlert = false
                    exitPomodoro()
                }
            }
    }
    
    

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


#Preview {
    CountdownView(difficulty: "Easy", focusTime: 3, restTime: 2, session: 1)
}

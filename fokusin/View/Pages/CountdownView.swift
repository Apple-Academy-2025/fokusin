import SwiftUI
import SwiftData
import Lottie
struct CountdownView: View {
    let difficulty: String
    let focusTime: Int
    let restTime: Int
    let session: Int
    
    @State private var timeRemaining: Int
    @State private var sessionCount: Int
    @State private var isFocusTime: Bool = true
    @State private var timerRunning = false
    @State private var timer: Timer?
    
    @State private var showAlertFail: Bool = false

    
    @State private var showExitAlert: Bool = false
    @State private var showSessionAlert: Bool = false
    @State private var sessionMessage: String = ""
    
    @State private var buttonText: String = "START"
    @State private var hasStarted: Bool = false
    
    @State private var isShaking = false
    
    @AppStorage("wasInactive") private var wasInactive: Bool = false
    
    @Environment(\.dismiss) private var dismiss  // Gunakan dismiss untuk kembali ke halaman sebelumnya
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase
    
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
            (isFocusTime ? Color.primer : Color.primer1)
                .ignoresSafeArea(.all)

            
            VStack {
                Text(isFocusTime ? "Focus Time" : "Break Time")
                    .font(.largeTitle)
                    .padding()
                    .fontWeight(.bold)
                ZStack {
                   
                    
                    Image(.telurUtuh)
                        .resizable()
                        .frame(width: 170, height: 200)
                        .padding(.bottom, 20)
                        .rotationEffect(.degrees(isShaking ? 5 : -5)) // 🔄 Goyangan kanan-kiri
                    
                        .onAppear {
                            withAnimation(
                                Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)
                            ) {
                                isShaking.toggle() }// Mulai animasi
                        }
                    
                    
                    
                }
                
                Text("\(formatTime(timeRemaining))")
                    .font(.system(size: 40, weight: .bold))
                    .padding()
                
                HStack(spacing: 20) {
                    Button(action: { handleButtonPress() }) {
                        Text(buttonText)
                            .foregroundColor(buttonText == "START" ? Color.tombol2 : Color.primer1)
                            .frame(width: 200, height: 50)
                            .background(buttonText == "START" ? Color.tombol : Color.tombol2)
                            .fontWeight(.bold)
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
                EmptyView()
            }
        }
        .overlay {
            if sessionCount > 0 {
                if showSessionAlert {
                    AlertWithoutButton(
                        isActive: $showSessionAlert,
                        title: "Session Changes",
                        message: sessionMessage
                    )
                }
            } else {
                // ✅ Popup "Congrats" tidak bisa ditutup otomatis
                AlertCongrats(
                    isActive: .constant(true), // 🚀 Selalu aktif hingga user menutup
                    title: "Greatss!!",
                    message: sessionMessage,
                    difficultyView: "\(difficulty)"
                ) {
                    print("Tombol ditekan!") // Contoh aksi saat tombol ditekan
                }
            }
            
            // Alert untuk keluar pomodoro
            if showExitAlert {
                CustomAlert(
                    isActive: $showExitAlert,
                    title: "Are you sure?!",
                    message: "Are you sure you want to leave the pomodoro? The egg will crack.",
                    buttonTitle: "EXIT"
                ) {
                    saveSession(isCompleted: false)
                    print("keluar ok")
                    exitPomodoro()
                }
            }
            
            if showAlertFail {
                AlertFail(
                    isActive: $showAlertFail,
                    title: "OH NO!!",
                    message: "Session failed because you exited the application!",
                    difficultyView: "\(difficulty)"
                ) {
                    exitPomodoro() // Keluar dari Pomodoro setelah menutup alert
                }
            }

        }
        .interactiveDismissDisabled(true)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                print("Active")
                if wasInactive {
                    wasInactive = false
                    if hasStarted {  // ✅ Jika Pomodoro sudah dimulai, maka gagal
                        sessionMessage = "Session failed because you exited the application!"
                        showAlertFail = true
                        saveSession(isCompleted: false)  // ✅ Simpan status gagal
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            exitPomodoro()  // Dismiss otomatis setelah 3 detik
                        }
                    }
                }
            } else if newPhase == .inactive || newPhase == .background {
                print("Inactive/Background")
                wasInactive = true
            }
        }
        
        
        
        
    }
    
    private func resumeTimer() {
        if !timerRunning {
            startTimer()
        }
    }
    
    private func handleButtonPress() {
        if buttonText == "START" {
            startTimer()
            buttonText = "STOP"
            hasStarted = true  // ✅ Tandai bahwa Pomodoro telah dimulai
        } else {
            stopTimer()
            showExitAlert = true
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
        if isFocusTime {
            // ✅ Sesi fokus selesai, kurangi sessionCount
            sessionCount -= 1

            if sessionCount > 0 {
                // ✅ Jika masih ada sesi tersisa, lanjut ke istirahat
                isFocusTime = false
                timeRemaining = restTime
                sessionMessage = "Time for a break! There are \(sessionCount) sessions left."
                showSessionAlert = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showSessionAlert = false
                    startTimer()
                }
            } else {
                // ✅ Jika sudah sesi terakhir, langsung Congrats tanpa istirahat
                saveSession(isCompleted: true)
                sessionMessage = "🎉 Congrats! You completed all sessions!"
                showSessionAlert = true
            }
        } else {
            // ✅ Sesi istirahat selesai, lanjut ke fokus berikutnya
            isFocusTime = true
            timeRemaining = focusTime
            sessionMessage = "Get ready! Focus time is about to start again."
            showSessionAlert = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showSessionAlert = false
                startTimer()
            }
        }
    }

    


    
    
    private func exitPomodoro() {
        stopTimer()
        dismiss()  // ✅ Kembali ke halaman utama ketika keluar
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func saveSession(isCompleted: Bool) {
        guard let difficultyLevel = Difficulty(rawValue: difficulty) else {
            print("⚠️ Error: Difficulty tidak valid")
            return
        }
        
        let newSession = PomodoroSession(
            difficulty: difficultyLevel,
            timeFocus: focusTime,
            session: session,
            totalFocus: focusTime * session,
            status: isCompleted
        )
        
        modelContext.insert(newSession)
        
        do {
            try modelContext.save()
            print("✅ Session saved successfully!")
        } catch {
            print("❌ Failed to save session: \(error.localizedDescription)")
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(difficulty: "Short", focusTime: 3, restTime: 3, session: 2)
    }
}


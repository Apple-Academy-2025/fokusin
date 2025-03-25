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
    
    @State private var showExitAlert: Bool = false
    @State private var showSessionAlert: Bool = false
    @State private var sessionMessage: String = ""
    @State private var buttonText: String = "Mulai"
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
            Color.primer.ignoresSafeArea(.all)
            
            VStack {
                Text(isFocusTime ? "Focus Time" : "Rest Time")
                    .font(.largeTitle)
                    .padding()
                    .fontWeight(.bold)
                ZStack {
//                    Circle()
//                        .fill(Color.primer1)
//                        .frame(width: 200, height: 200)
//                    Section{
//                        LottieView(animation: .named("EmpetyEgg"))
//                            .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
//                            .frame(width: 450,height: 350)
//                            
//                    }
//                    .frame(width: 200, height: 200)

                    Image(.telurUtuh)
                        .resizable()
                        .frame(width: 180, height: 200)
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
                            .foregroundColor(buttonText == "Mulai" ? Color.tombol2 : Color.primer1)
                            .frame(width: 200, height: 50)
                            .background(buttonText == "Mulai" ? Color.tombol : Color.tombol2)
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
            if sessionCount > 1 {
                if showSessionAlert {
                    AlertWithoutButton(
                        isActive: $showSessionAlert,
                        title: "Perubahan Sesi",
                        message: sessionMessage
                    )
                }
            } else {
                if showSessionAlert {
                    AlertWithoutButton(
                        isActive: $showSessionAlert,
                        title: "Hebatt!!",
                        message: sessionMessage
                    )
                }
            }
            if showExitAlert {
                CustomAlert(
                    isActive: $showExitAlert,
                    title: "Keluar Nih?!",
                    message: "Kamu yakin akan meninggalkan pomodoro? telur nya nanti pecah",
                    buttonTitle: "Keluar"
                ){
                    //                    saveSession(isCompleted: false)
                    saveSession(isCompleted: false)
                    print("keluar ok")
                    exitPomodoro()
                }
            }
        }.interactiveDismissDisabled(true)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active")
                    if wasInactive {
                        wasInactive = false
                        if hasStarted {  // ✅ Jika Pomodoro sudah dimulai, maka gagal
                            sessionMessage = "Sesi gagal karena kamu keluar dari aplikasi!"
                            showSessionAlert = true
                            saveSession(isCompleted: false)  // ✅ Simpan status gagal
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
        if buttonText == "Mulai" {
            startTimer()
            buttonText = "Stop"
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
            sessionCount -= 1
            if sessionCount > 0 {
                isFocusTime = false
                timeRemaining = restTime
                sessionMessage = "Waktunya istirahat! Sisa \(sessionCount) sesi lagi."
                showSessionAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    showSessionAlert = false
                    startTimer()
                }
            } else {
                saveSession(isCompleted: true)
                sessionMessage = "Pomodoro selesai! Kerja bagus! 🎉"
                showSessionAlert = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    dismiss()  // ✅ Kembali ke halaman utama setelah selesai
                }
                
            }
        } else {
            sessionCount -= 1
            isFocusTime = true
            timeRemaining = focusTime
            sessionMessage = "Bersiap! Waktu fokus akan dimulai lagi."
            showSessionAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
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
        CountdownView(difficulty: "Easy", focusTime: 10, restTime: 5, session: 2)
    }
}


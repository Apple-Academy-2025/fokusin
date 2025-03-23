import SwiftUI
import SwiftData

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
    @State private var buttonText: String = "Start"

    @Environment(\.dismiss) private var dismiss  // Gunakan dismiss untuk kembali ke halaman sebelumnya
    @Environment(\.modelContext) private var modelContext

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
        .onChange(of: showExitAlert) {
            if showExitAlert {
                stopTimer()
            } else {
                resumeTimer()
            }
        }
    }

    private func resumeTimer() {
        if !timerRunning {
            startTimer()
        }
    }

    private func handleButtonPress() {
        if buttonText == "Start" {
            startTimer()
            buttonText = "Stop"
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

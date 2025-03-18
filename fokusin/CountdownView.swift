import SwiftUI

struct CountdownView: View {
    let difficulty: String
    @State private var timeRemaining: Int
    @State private var timerRunning = false
    @State private var timer: Timer?
    
    // Untuk pop-up alert
    @State private var showPopUp: Bool = false
    @State private var popUpMessage: String = ""
    
    // Tracking sesi, misalnya 4 sesi (2x fokus, 2x istirahat)
    // [INI PERLU DIBIKIN DINAMIS DENGAN DIBIKIN (n * 2) contoh diatas 4 itu total seluruh sesi]
    @State private var sessionCount: Int = 4
    @State private var isFocusTime: Bool = true // Fokus dulu, lalu istirahat

    init(difficulty: String) {
        self.difficulty = difficulty
        self._timeRemaining = State(initialValue: CountdownView.getInitialTime(for: difficulty, isFocusTime: true))
    }

    var body: some View {
        VStack {
            Text(isFocusTime ? "Focus Time" : "Rest Time")
                .font(.largeTitle)
                .padding()

            Text("\(formatTime(timeRemaining))")
                .font(.system(size: 40, weight: .bold))
                .padding()

            HStack(spacing: 20) {
                Button(action: { toggleTimer() }) {
                    Text(timerRunning ? "Pause" : "Start")
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(timerRunning ? Color.red : Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Button(action: { resetTimer() }) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .frame(width: 100, height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding()
        .onDisappear {
            stopTimer()
        }
        
        // Menampilkan alert pop-up
        .alertView(isPresented: $showPopUp, onDismiss: { startNextSession() }) {
            VStack {
                Text(popUpMessage)
                    .font(.headline)
                    .padding()
                Text("Sesi tersisa: \(sessionCount)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: 250, height: 150)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }

    private func toggleTimer() {
        if timerRunning {
            stopTimer()
        } else {
            startTimer()
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

    private func resetTimer() {
        stopTimer()
        sessionCount = 4
        isFocusTime = true
        timeRemaining = CountdownView.getInitialTime(for: difficulty, isFocusTime: true)
    }

    private func handleSessionEnd() {
        if sessionCount > 0 {
            showPopUp = true
            popUpMessage = isFocusTime ? "Focus Time Selesai!" : "Rest Time Selesai!"
            
            // Tunggu 5 detik sebelum menutup pop-up dan lanjut sesi berikutnya
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                showPopUp = false
            }
        }
    }

    private func startNextSession() {
        if sessionCount > 0 {
            sessionCount -= 1
            isFocusTime.toggle()
            timeRemaining = CountdownView.getInitialTime(for: difficulty, isFocusTime: isFocusTime)
            startTimer()
        }
//        jika sudah harusnya masuk kedalam page congratulation
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    static func getInitialTime(for difficulty: String, isFocusTime: Bool) -> Int {
        if isFocusTime {
            switch difficulty {
            case "ez": return 4  // 15 menit
            case "med": return 1500 // 25 menit
            case "hard": return 2700 // 45 menit
            case "custom": return 1800 // 30 menit default
            default: return 0
            }
        } else {
            return 3 // Istirahat 5 menit untuk semua mode
        }
    }
}

#Preview {
    CountdownView(difficulty: "ez")
}

//
//  StartView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 20/03/25.
//





import SwiftUI

struct StartView: View {
    @StateObject private var viewModel = DifficultyViewModel()
    let difficulty: String

    // State untuk menyimpan nilai yang diambil dari ViewModel
    @State private var focusTime: Int = 0
    @State private var restTime: Int = 0
    @State private var session: Int = 0

    init(difficulty: String) {
        self.difficulty = difficulty
        
        // Ambil nilai default dari ViewModel berdasarkan difficulty
        if let mode = DifficultyViewModel().getMode(by: difficulty) {
            _focusTime = State(initialValue: mode.time.focus)
            _restTime = State(initialValue: mode.time.rest)
            _session = State(initialValue: mode.time.section)
        }
    }

    var body: some View {
        ZStack {
            Color.primer.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 95)

                // 🔵 Icon lingkaran dengan nama mode
                ZStack {
                    Circle()
                        .fill(Color.primer1)
                        .frame(width: 200, height: 200)
                    
                    Text(difficulty.uppercased())
                        .foregroundColor(.primer)
                        .font(.largeTitle)
                }
                .padding(.bottom, 20)

                if viewModel.getMode(by: difficulty) != nil {
                    VStack {
                        if difficulty == "custom" {
                            // 🔹 Jika mode custom, gunakan CustomTimePicker
                            VStack {
                                CustomTimePicker(title: "⏳ Fokus", totalSeconds: $focusTime)
                                CustomTimePicker(title: "💤 Istirahat", totalSeconds: $restTime)

                                Picker("🔁 Sesi", selection: $session) {
                                    ForEach(1..<11, id: \.self) { count in
                                        Text("\(count)x").tag(count)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxWidth: .infinity, maxHeight: 100)
                                .background(Color.tombol)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            // 🔹 Jika mode bukan custom, tampilkan nilai default
                            HStack(spacing: 10) {
                                let timeDetails = [
                                    ("⏳ Fokus", formatTime(focusTime)),
                                    ("💤 Istirahat", formatTime(restTime)),
                                    ("🔁 Sesi", "\(session)x")
                                ]
                                
                                ForEach(timeDetails, id: \.0) { detail in
                                    VStack(spacing: 10) {
                                        Text(detail.0)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(detail.1)
                                            .font(.title2)
                                            .frame(width: 80, height: 60)
                                            .background(Color.tombol)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 55))
                }

                // 🔥 Navigation ke Timer
                NavigationLink(destination: CountdownView(
                    difficulty: difficulty,
                    focusTime: focusTime,
                    restTime: restTime,
                    session: session
                )) {
                    Text("Start Timer")
                        .foregroundColor(.primer)
                        .frame(width: 200, height: 50)
                        .background(Color.tombol2)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .frame(maxWidth: .infinity, maxHeight: 85)

                Spacer(minLength: 90)
            }
        }
    }

    /// Format waktu dari detik ke "MM:SS"
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    StartView(difficulty: "Easy")
}





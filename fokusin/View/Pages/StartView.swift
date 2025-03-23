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
                
                Spacer(minLength: 105)

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
                        if difficulty == "Custom" {
                            VStack {
                                CustomTimePicker(title: "⏳ Fokus", totalSeconds: $focusTime)
                               
                                CustomTimePicker(title: "💤 Istirahat", totalSeconds: $restTime)

                                // 🔁 Pilihan sesi dengan tombol
                                Text("Sesi")
                                HStack {
                                    Button(action: {
                                        if session > 1 { session -= 1 }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.red)
                                    }

                                    Text("\(session)x")
                                        .font(.title)
                                        .frame(width: 80, height: 60)
                                        .background(Color.tombol)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                    Button(action: {
                                        if session < 10 { session += 1 }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.green)
                                    }
                                }
                                .padding()
                            }
                        }

                            else {
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
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .edgesIgnoringSafeArea(.bottom)
                    
                    
                }

                

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
    StartView(difficulty: "Custom")
}





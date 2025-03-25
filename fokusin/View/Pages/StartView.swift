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
    
    @State private var focusTime: Int = 0
    @State private var restTime: Int = 0
    @State private var session: Int = 0
    
    // 🔥 State untuk animasi goyangan telur
    @State private var isShaking = false
    
    init(difficulty: String) {
        self.difficulty = difficulty
    }
    
    var body: some View {
        ZStack {
            Color.primer.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 105)
                
                Ellipse()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
                    .offset(x: 0, y: 220)
                
                // 🔥 Animasi Telur Goyang
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
                
                VStack {
                    if difficulty == "Custom" {
                        VStack {
                            CustomTimePicker(title: "⏳ Fokus", totalSeconds: $focusTime)
                            CustomTimePicker(title: "💤 Istirahat", totalSeconds: $restTime)
                            
                            Text("Sesi")
                            HStack {
                                Button(action: { if session > 1 { session -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                }
                                
                                Text("\(session)x")
                                    .font(.title)
                                    .frame(width: 80, height: 60)
                                    .background(Color.tombol)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Button(action: { if session < 10 { session += 1 } }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding()
                        }
                    } else {
                        HStack(spacing: 10) {
                            FocusModeView(
                                focusTime: focusTime,
                                restTime: restTime,
                                sessionCount: session
                            )
                            .padding()
                        }
                    }
                    
                    NavigationLink(destination: CountdownView(
                        difficulty: difficulty,
                        focusTime: focusTime,
                        restTime: restTime,
                        session: session
                    )) {
                        Text("Mulai")
                            .foregroundColor(.tombol2)
                            .fontWeight(.bold)
                            .frame(width: 200, height: 50)
                            .background(Color.tombol)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .frame(maxWidth: .infinity, maxHeight: 85)
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .edgesIgnoringSafeArea(.bottom)
                
                Spacer(minLength: 90)
            }
        }
        .onAppear {
            if let mode = viewModel.getMode(by: difficulty) {
                self.focusTime = mode.time.focus
                self.restTime = mode.time.rest
                self.session = mode.time.section
            }
        }
    }
}


#Preview {
    StartView(difficulty: "Medium")
}





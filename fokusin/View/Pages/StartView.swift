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
                
                Text("Mode \(difficulty)")
                    .font(.title)
                    .fontWeight(.bold)
                
                Ellipse()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 20)
                    .offset(x: 0, y: 220)
                
                // 🔥 Animasi Telur Goyang
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
                
                VStack {
                    if difficulty == "Custom" {
                        VStack {
                            CustomTimePicker(title: "Fokus",icon: "target", totalSeconds: $focusTime)
                            CustomTimePicker(title: "Istirahat",icon: "clock", totalSeconds: $restTime)
                            
                            HStack {
                                // 🔹 Ikon di sebelah kiri
                                HStack(spacing:5){
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.title2)
                                        .clipShape(Circle())
                                        .foregroundColor(.tombol2)

                                    Text("Sesi")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }

                                Divider()
                                       .frame(width: 94)
                                
                                // 🔹 Tombol sesi
                                HStack(spacing: 8) {
                                    Button(action: { if session > 1 { session -= 1 } }) {
                                        Text("−")
                                            .font(.title)
                                            .frame(width: 30, height: 30) // Ukuran tombol
                                            .background(Color.tombol)
                                            .foregroundColor(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }

                                    Text("\(session)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .frame(width: 30)

                                    Button(action: { if session < 10 { session += 1 } }) {
                                        Text("+")
                                            .font(.title)
                                            .frame(width: 30, height: 30)
                                            .background(Color.tombol)
                                            .foregroundColor(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                }
                            }
                            
                            
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
                        Text("NEXT")
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
            }.padding()
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
    StartView(difficulty: "Short")
}





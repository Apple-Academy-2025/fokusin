//
//  ContentView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//


import SwiftUI

struct Main: View {
    @State private var difficulty: String? = nil
    @State private var navigationPath = NavigationPath()
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    @State private var buttonOffset: CGFloat = 100
    @State private var buttonOpacity = 0.0
    @State private var bounceEffect = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.primer.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header dengan logo teks dan ikon profil
                    HStack {
                        
                        Image(.home)
                            .resizable()
                            .frame(width: 105, height: 40)
                        Spacer()
                        NavigationLink(destination: HistoryView()) {
                            Image(.telurUtuh)
                                .resizable()
                                .frame(width: 25, height: 30)
                                .padding(12)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.tombol2, lineWidth: 3)
                                )
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, -15)
                    
                    
                    Spacer()
                    
                    // Animasi Pop-Up + Bounce Effect
                    Ellipse()
                        .fill(Color.gray.opacity(0.3)) // Warna bayangan
                        .frame(width: 150, height: 20) // Ukuran oval
                        .offset(x:0,y: 220)
                
                    Image(.telurUtuh)
                        .resizable()
                        .frame(width: 170, height: 200)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0), value: logoScale)
                        .animation(.easeIn(duration: 0.5), value: logoOpacity)
                        .offset(y: bounceEffect ? -5 : 0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: bounceEffect)
                    
                    Spacer()
                    
                    // Animasi Slide-Up Button
                    VStack {
                        VStack {

                            VStack(spacing: 10) {
                                difficultyButton(label: "Short")
                                difficultyButton(label: "Reguler")
                                difficultyButton(label: "Long")
                            }
                            
                            Button(action: { difficulty = "Custom"; navigate() }) {
                                Text("Custom")
                                    .foregroundColor(.primer)
                                    .frame(width: 280, height: 70)
                                    .fontWeight(.bold)
                                    .background(.tombol2)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10) // Bentuk border sesuai clipShape
                                            .stroke(.primer, lineWidth: 2) // Warna dan ketebalan border
                                    )
                                
                            }
                            
//                            Spacer() // ✅ Spacer dengan tinggi 11
                        }
                        .padding(.bottom, 80)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(y: buttonOffset)
                        .opacity(buttonOpacity)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: buttonOffset)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: buttonOpacity)
    
                    }
                    .padding(.vertical, 10)
                    .frame(width: .infinity, height: 450)
                    .background(Color.primer1)
                    .cornerRadius(40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.bottom)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: String.self) { difficulty in
                ExplanationView(difficulty: difficulty)
            }
            .onAppear {
                withAnimation {
                    logoScale = 1.0
                    logoOpacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    buttonOffset = 0
                    buttonOpacity = 1.0
                }
                
                // Aktifkan efek bounce setelah muncul
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    bounceEffect = true
                }
            }
        }
    }
    
    private func difficultyButton(label: String) -> some View {
        Button(action: { difficulty = label; navigate() }) {
            Text(label)
                .foregroundColor(.tombol2)
                .frame(width: 280, height: 70)
                .background(.tombol)
                .fontWeight(.bold)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Bentuk border sesuai clipShape
                        .stroke(Color.tombol2, lineWidth: 2) // Warna dan ketebalan border
                )
        }

    }
    
    private func navigate() {
        if let difficulty = difficulty {
            navigationPath.append(difficulty)
        }
    }
}

#Preview {
    Main()
}



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
                        Text("Fokusin")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.tombol)
                        
                        Spacer()
                        
//                        Arah ke history
                        // ✅ Perbaiki NavigationLink agar meneruskan modelContext
                        
                        NavigationLink(destination: HistoryView()) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.tombol2)
                            }

                    }
                    .padding(.horizontal)
                    .padding(.top, -15) // Beri padding atas agar tidak terlalu mepet
                    
                    Spacer()
                    
                    // Animasi Pop-Up + Bounce Effect
                    Circle()
                        .fill(.primer1)
                        .frame(width: 200, height: 200)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0), value: logoScale)
                        .animation(.easeIn(duration: 0.5), value: logoOpacity)
                        .offset(y: bounceEffect ? -5 : 0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: bounceEffect)
                    
                    Spacer()
                    
                    // Animasi Slide-Up Button
                    VStack {
                        VStack(spacing: 10) {
                            difficultyButton(label: "Easy")
                            difficultyButton(label: "Medium")
                            difficultyButton(label: "Hard")
                        }
                        
                        Button(action: { difficulty = "Custom"; navigate() }) {
                            Text("Custom")
                                .foregroundColor(.primer)
                                .frame(width: 200, height: 50)
                                .background(.tombol2)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .padding(.top, 10)
                        
                    }
                    .offset(y: buttonOffset)
                    .opacity(buttonOpacity)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: buttonOffset)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: buttonOpacity)
                    
                    Spacer()
                }
                .padding()
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
                .frame(width: 200, height: 50)
                .background(.tombol)
                .clipShape(RoundedRectangle(cornerRadius: 10))
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



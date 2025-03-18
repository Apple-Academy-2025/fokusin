//
//  ContentView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//


import SwiftUI

struct ContentView: View {
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
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    // Animasi Pop-Up + Bounce Effect
                    Circle()
                        .fill(Color(red: 0.4, green: 0.8, blue: 0.6))
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
                        HStack(spacing: 10) {
                            difficultyButton(label: "ez")
                            difficultyButton(label: "med")
                            difficultyButton(label: "hard")
                            
                        }
                        
                        Button(action: { difficulty = "custom"; navigate() }) {
                            Text("custom")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
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
                .foregroundColor(.white)
                .frame(width: 60, height: 40)
                .background(Color.blue)
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
    ContentView()
}


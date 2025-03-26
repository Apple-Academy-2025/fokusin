//
//  SplashScreenView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color.primer1.edgesIgnoringSafeArea(.all)
            
            if isActive {
                if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                    Main()
                        .transition(.opacity) // Efek fade
                } else {
                    OnBoarding()
                        .transition(.move(edge: .bottom)) // Slide dari kanan
                }
            } else {
                VStack {
                    Image(.splashIcon)
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1)) {
                                self.size = 0.9
                                self.opacity = 1.0
                            }
                        }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 0.5)) { // Animasi transisi
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}



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
        
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image(systemName: "cloud")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    Text("Fokusin")
                        .font(.system(size: 50, weight: .medium))
                }
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
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

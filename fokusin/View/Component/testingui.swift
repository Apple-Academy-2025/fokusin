//
//  ExplanationView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//

import SwiftUI
import Lottie

struct testingui: View {
    @StateObject private var viewModel = DifficultyViewModel()
    @State private var logoScale = 0.5
    @State private var logoOpacity = 0.0
    @State private var buttonOffset: CGFloat = 100
    @State private var buttonOpacity = 0.0
    @State private var bounceEffect = false
    let difficulty: String
    
    var body: some View {
        ZStack {
            Color.primer.edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Spacer().frame(height: 10)
                    
                    Text("tes")
                        .font(.title2)
                        .fontWeight(.regular)
                        .padding()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // ⏰ Menampilkan daftar detail aktivitas
                  
                  
                    .frame(maxWidth: .infinity, maxHeight: 160)
                }
                .padding(.top, 30)
                .padding(.bottom,80)
                .background(Color.primer1)
                .cornerRadius(40)
                .overlay(alignment: .top) {
                    Text( "Mode")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.primer)
                        .zIndex(10)
                        .padding(.horizontal, 45)
                        .padding(.vertical, 5)
                        .background(.tombol2)
                        .cornerRadius(10)
                        .offset(y: -20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                
            }
            
        }
    }
}

// 🛠️ Preview
#Preview {
    testingui(difficulty: "Easy")
}


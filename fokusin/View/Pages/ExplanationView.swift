//
//  ExplanationView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//

import SwiftUI
import Lottie

struct ExplanationView: View {
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
                Spacer(minLength: 95)
                
            
                ZStack {
                    Ellipse()
                        .fill(Color.gray.opacity(0.3)) // Warna bayangan
                        .frame(width: 150, height: 20) // Ukuran oval
                        .offset(x:0,y: 100)
                    
                    LottieView(animation: .named("tes2"))
                        .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                        .frame(width: 300, height: 250)
                    
                    
                    Spacer()
                }
                
                
                
                
                VStack {
                    
                    if let selectedMode = viewModel.getMode(by: difficulty) {
                        
                        Spacer().frame(height: 10)
                        
                        VStack(alignment: .leading) {
                        Text(selectedMode.description)
                            .font(.title2)
                            .fontWeight(.regular)
                            .padding()
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        // ⏰ Menampilkan daftar detail aktivitas
                        
        
                            VStack(alignment:.leading,spacing:5){
                                ForEach(selectedMode.detail, id: \.self) { activity in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 5))
                                            
                                        Text(activity)
                                            .font(.body)
                                    }.padding(.horizontal,22)
                                }
                            }
                        }.padding(.horizontal)
                        
                        FocusModeView(
                            focusTime: selectedMode.time.focus,
                            restTime: selectedMode.time.rest,
                            sessionCount: selectedMode.time.section
                        )
                        .padding()
                        
                        NavigationLink(destination: StartView(difficulty: difficulty)) {
                            Text("NEXT")
                                .font(.title2)
                                .foregroundColor(.tombol2)
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50)
                                .background(Color.tombol)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: 160)
                        Spacer()
                    } else {
                        Text("Mode tidak ditemukan")
                            .font(.title2)
                    }
                }
                .padding(.top, 30)
                .padding(.bottom,80)
                .background(Color.primer1)
                .cornerRadius(40)
                .overlay(alignment: .top) {
                    Text(viewModel.getMode(by: difficulty)?.title ?? "Mode Tidak Dikenal")
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
    ExplanationView(difficulty: "Custom")
}


//
//  ExplanationView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 16/03/25.
//

import SwiftUI

struct ExplanationView: View {
    @StateObject private var viewModel = DifficultyViewModel()
    let difficulty: String
    
    var body: some View {
        ZStack {
            Color.primer.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer(minLength: 95)

                // 🔵 Icon lingkaran dengan nama mode
                ZStack {
                    Circle()
                        .fill(Color.primer1)
                        .frame(width: 200, height: 200)
                    
                    Text(difficulty.uppercased())
                        .foregroundColor(.primer)
                        .font(.largeTitle)
                }
                
               
                VStack {
                    
                    if let selectedMode = viewModel.getMode(by: difficulty) {
                       
                        Spacer().frame(height: 10)
                        
                        Text(selectedMode.description)
                            .font(.title2)
                            .fontWeight(.regular)
                            .padding()
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        // ⏰ Menampilkan daftar detail aktivitas
                        VStack(alignment: .leading, spacing: 5) {
                            Text("📌 Aktivitas Rekomendasi:")
                                .font(.headline)
                                .padding(.top, 10)
                            
                            ForEach(selectedMode.detail, id: \.self) { activity in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(activity)
                                        .font(.body)
                                }
                            }
                        }
                        .padding()
                        
                        NavigationLink(destination: StartView(difficulty: difficulty)) {
                            Text("Start Timer")
                                .foregroundColor(.primer)
                                .frame(width: 200, height: 50)
                                .background(Color.tombol2)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 160)
                    } else {
                        Text("Mode tidak ditemukan")
                            .font(.title2)
                    }
                }
                .padding(.top, 30)
                .background(Color.primer1)
                .cornerRadius(40)
                .overlay(alignment: .top) {
                    Text(viewModel.getMode(by: difficulty)?.title ?? "Mode Tidak Dikenal")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(.black)
                        .zIndex(10)
                        .padding(.horizontal, 45)
                        .padding(.vertical, 5)
                        .background(.primer1)
                        .cornerRadius(10)
                        .offset(y: -20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
                
            }
     
        }
    }
}

// 🛠️ Preview
#Preview {
    ExplanationView(difficulty: "Easy")
}


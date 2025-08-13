//
//  ContentView.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 21/05/25.
//

import SwiftUI

struct Homepageview: View {
    let totalMinutes = 17 * 60 + 30   // ganti dengan data asli
    let todayMinutes = 95
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Bagian header
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.orange)
                        .frame(height: 450)
                        .ignoresSafeArea(edges: .top)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(){
                            Text("Fokusin")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                                .padding(.leading, 20)
                            Spacer()
                            //                            ini logo masuk ke page history
                            NavigationLink {
                                HistoryView()
                            } label: {
                                CircularIcon(
                                    imageName: "History",   // 🥚 gambar seperti contohmu
                                    size: 24,
                                    ringColor: .white,      // ganti ke Color("Text2") kalau mau
                                    ringWidth: 2
                                )
                            }
                            .padding(.top,45)
                            .buttonStyle(.plain)
                            
                        }
                        .padding(.trailing, 30)
                     
                        
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.chiken)
                                .frame(height: 250)
                                .padding(.horizontal, 20)
                            
                            Image("CharNest1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 280)
                                .padding(.top, 45)
                        }
                    }
                }
                
                // Tombol dari dummy presets
                VStack(spacing: 20) {
                    ForEach(PomodoroData.presets, id: \.id) { preset in
                        NavigationLink(
                            destination: DetailViewPage(modeTitle: preset.title)
                        ) {
                            ButtonHomePage(title: preset.title)   // <- tanpa closure
                        }
                        .buttonStyle(.plain)
                    }
                    
                    NavigationLink(
                        destination: DetailViewPage(modeTitle: "Mode Kustom")
                    ) {
                        ButtonHomePage(title: "Mode Kustom")     // <- tanpa closure
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 90)
            }
            .background(Color.bgYellow.ignoresSafeArea())
        }
        .tint(Color.text2)
    }
}

struct CircularIcon: View {
    var imageName: String
    var size: CGFloat = 24
    var ringColor: Color = .white
    var ringWidth: CGFloat = 2
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(ringColor, lineWidth: ringWidth)
                .frame(width: size + 16, height: size + 16)
            
            Image(imageName)                // aset PNG transparan (si telur)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.06), radius: 1, x: 0, y: 1)
        }
        .padding(4)                         // area tap lebih lega
        .contentShape(Circle())
    }
}

#Preview {
    Homepageview()
}

//
//  CustomTimePicker.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 20/03/25.
//

import SwiftUI

struct CustomTimePicker: View {
    let title: String
    @Binding var totalSeconds: Int
    
    // State untuk menyimpan menit dan detik secara terpisah
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                // 🔹 Picker untuk Menit (0 - 59)
                Picker("Menit", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { min in
                        Text("\(min) min").tag(min)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 80, maxHeight: 100)
                .clipped()
                
                Text(":")
                    .font(.largeTitle)
                    .padding(.horizontal, 5)

                // 🔹 Picker untuk Detik (0 - 59)
                Picker("Detik", selection: $seconds) {
                    ForEach(0..<60, id: \.self) { sec in
                        Text("\(sec) sec").tag(sec)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 80, maxHeight: 100)
                .clipped()
            }
//            .background(Color.tombol)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .onChange(of: minutes) {
            updateTotalSeconds()
        }
        .onChange(of: seconds) {
            updateTotalSeconds()
        }

        .onAppear {
            // Saat tampilan muncul, pecah total detik menjadi menit dan detik
            minutes = totalSeconds / 60
            seconds = totalSeconds % 60
        }
    }
    
    /// 🔹 Fungsi untuk mengupdate total detik dari `minutes` dan `seconds`
    private func updateTotalSeconds() {
        totalSeconds = (minutes * 60) + seconds
    }
}


//
//  CustomTimePicker.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 20/03/25.
//

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
    
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    var body: some View {
        VStack(spacing: 2) { // 🔥 Jarak antar elemen lebih kecil
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(alignment: .center, spacing: 5) { // 🔥 Kurangi spacing agar lebih rapat
                // 🔹 Picker Menit
                VStack {
                    Text("Min")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Picker("Menit", selection: $minutes) {
                        ForEach(0..<60, id: \.self) { min in
                            Text("\(min)").tag(min)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 70, height: 120) // 🔥 Kurangi tinggi
                    .clipped()
                }
                
                // 🔹 Pemisah ":"
                Text(":")
                    .font(.title) // 🔥 Sedikit lebih kecil
                    .padding(.horizontal, 3) // 🔥 Kurangi padding

                // 🔹 Picker Detik
                VStack {
                    Text("Sec")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Picker("Detik", selection: $seconds) {
                        ForEach(0..<60, id: \.self) { sec in
                            Text("\(sec)").tag(sec)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 70, height: 120) // 🔥 Kurangi tinggi
                    .clipped()
                }
            }
        }
        .onChange(of: minutes) {
            updateTotalSeconds()
        }
        .onChange(of: seconds) {
            updateTotalSeconds()
        }
        .onAppear {
            minutes = totalSeconds / 60
            seconds = totalSeconds % 60
        }
    }
    
    private func updateTotalSeconds() {
        totalSeconds = (minutes * 60) + seconds
    }
}








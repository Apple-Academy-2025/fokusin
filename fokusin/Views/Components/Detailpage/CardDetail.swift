//
//  DetailComponent.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 12/07/25.
//

import SwiftUI

struct CardDetail: View {
    var title: String
    var subTitle: String

    var body: some View {
        // Card = konten + background (bukan shape terpisah)
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 24, weight: .semibold))

            Text(subTitle)
                .multilineTextAlignment(.center)
        }
        .foregroundColor(Color("Text2"))
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .frame(width: 300, height: 300) // ini “frame”-nya
        .background(Color.orange)     // kasih background langsung ke konten
        .cornerRadius(20)             // sudut tumpul tanpa RoundedRectangle view
        .overlay(                     // gambar ditempel di atas card
            Image("ChickenDetail")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .offset(y: -136),      // separuh tinggi gambar biar ‘nempel’ di atas
            alignment: .top
        )
        .padding(.top, 90)            // ruang untuk gambar yang nongol di atas
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    CardDetail(title: "Mode Panjang", subTitle: "Sesi Pomodoro mode panjang untuk pekerjaan mendalam.")
}

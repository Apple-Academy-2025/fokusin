//
//  StatCard.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 25/03/25.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let count: Int
    let label: String
    let status: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(icon)
                .resizable()
                .frame(width: 24, height: 30)
                .padding(8)
                .background(status ? Color("primer") : Color.red.opacity(0.2)) // 🔥 Warna berdasarkan status
                .cornerRadius(8)
            
            Divider()
                .frame(width: 2)
            
            VStack {
                Text("\(count) Telur")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.brown)
                
                
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(.brown.opacity(0.8))
            }
        }
        .padding()
        .frame(width: 140, height: 70)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 10) {
        StatCard(icon: "CrackEgg", count: 2, label: "Gagal", status: false)
        StatCard(icon: "TelurUtuh", count: 2, label: "Berhasil", status: true)
    }
}



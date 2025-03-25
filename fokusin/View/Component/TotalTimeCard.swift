//
//  StatCard.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 25/03/25.
//

import SwiftUI

struct TotalTimeCard: View {
    let icon: String
    let count: Int
    let label: String
    let status: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(systemName:"\(icon)")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(8)
                .foregroundColor(.tombol2)
                .fontWeight(.bold)
                .background(status ? Color.primer1 : Color.blue.opacity(0.2)) // 🔥 Warna berdasarkan status
                .cornerRadius(8)
            
            Divider()
                .frame(width: 2)
            
            VStack {
                Text(label)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color.brown)
                
                
                Text("\(count)")
                    .font(.system(size: 14))
                    .foregroundColor(.brown.opacity(0.8))
            }
            
        }
        .padding()
        .frame(width: 165, height: 70)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    HStack(spacing: 10) {
        TotalTimeCard(icon: "clock", count: 2, label: "Total waktu", status: false)
        TotalTimeCard(icon: "target", count: 2, label: "hari ini", status: true)
    }
}



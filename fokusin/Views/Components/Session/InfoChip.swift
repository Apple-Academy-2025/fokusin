//
//  InfoChip.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 09/08/25.
//

import SwiftUI

struct InfoChip: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2.bold())
            Text(text)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(Color("Text2"))
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Text2").opacity(0.15), lineWidth: 1)
                )
        )
    }
}

#Preview {
    InfoChip(icon: "bolt.fill", text: "08:00")
}

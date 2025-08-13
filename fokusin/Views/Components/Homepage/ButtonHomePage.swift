//
//  ButtonHomapage.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 11/07/25.
//

import SwiftUI

struct ButtonHomePage: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(Color("Text2"))
            .padding(.horizontal, 32)
            .padding(.vertical, 20)
            .frame(width: 320)
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("Stroke-1"), lineWidth: 2)
            )
            .contentShape(Rectangle()) // area tap full
    }
}

#Preview {
    ButtonHomePage(title: "Mode Pendek")
}

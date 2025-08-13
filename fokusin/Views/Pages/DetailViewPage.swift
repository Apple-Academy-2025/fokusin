//
//  DetailViewPage.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 11/07/25.
//

import SwiftUI

struct DetailViewPage: View {
    let modeTitle: String
    
    // Preset dari dummy (kalau ada)
    private var preset: PomodoroPreset? {
        PomodoroData.presets.first { $0.title == modeTitle }
    }
    
    // State untuk Mode Kustom
    @State private var customFocus = 25
    @State private var customBreak = 5
    @State private var customCycles = 4
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 80)
                .fill(Color.bgCircle)
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .zIndex(-1)
                .offset(y:200)
            
            VStack(spacing: 20) {
                if let p = preset {
                    // ===== PRESET (Pendek/Sedang/Panjang) =====
                    CardDetail(title: p.title, subTitle: p.description)
                    CardTimeDetail(
                        focusMinutes: .constant(p.focusMinutes),
                        breakMinutes: .constant(p.breakMinutes),
                        cycles: .constant(p.cycles),
                        editable: false
                    )

                    NavigationLink(
                        destination: StartSessionView(
                            title: p.title,
                            focusMinutes: p.focusMinutes,
                            breakMinutes: p.breakMinutes,
                            cycles: p.cycles
                        )
                    ) {
                        ButtonHomePage(title: "Mulai")
                    }
                    .buttonStyle(.plain)
                    
                } else {
                    // ===== MODE KUSTOM =====
                    CardDetail(title: "Mode Kustom", subTitle: "Atur fokus, jeda, dan siklus sesuai kebutuhanmu.")
                    
                    CardTimeDetail(
                        focusMinutes: $customFocus,
                        breakMinutes: $customBreak,
                        cycles: $customCycles,
                        editable: true
                    )
                    
                    NavigationLink(
                        destination: StartSessionView(
                            title: "Mode Kustom",
                            focusMinutes: customFocus,
                            breakMinutes: customBreak,
                            cycles: customCycles
                        )
                    ) {
                        ButtonHomePage(title: "Mulai")
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgYellow)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    DetailViewPage(modeTitle: "Mode Pendek")
}

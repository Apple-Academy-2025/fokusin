//
//  PomodoroData.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 08/08/25.
//

import Foundation

struct PomodoroData {
    static let presets: [PomodoroPreset] = [
        PomodoroPreset(
            id: "short",
            title: "Mode Pendek",
            focusMinutes: 15,
            breakMinutes: 3,
            cycles: 2,
            description: "Sesi Pomodoro mode pendek, cocok untuk fokus singkat."
        ),
        PomodoroPreset(
            id: "medium",
            title: "Mode Sedang",
            focusMinutes: 25,
            breakMinutes: 5,
            cycles: 4,
            description: "Sesi Pomodoro mode sedang, seimbang antara fokus dan jeda."
        ),
        PomodoroPreset(
            id: "long",
            title: "Mode Panjang",
            focusMinutes: 45,
            breakMinutes: 10,
            cycles: 3,
            description: "Sesi Pomodoro mode panjang untuk pekerjaan mendalam."
        )
    ]
    
    // Default settings
    static let defaults = PomodoroPresetFile.Defaults(
        autoStartBreak: true,
        autoStartFocus: false,
        sound: "bell-1"
    )
}


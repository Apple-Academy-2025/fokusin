//
//  PomodoroModels.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 08/08/25.
//

import Foundation

struct PomodoroPresetFile: Codable {
    struct Defaults: Codable, Equatable, Hashable {
        let autoStartBreak: Bool
        let autoStartFocus: Bool
        let sound: String
    }
}

struct PomodoroPreset: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let title: String
    let focusMinutes: Int
    let breakMinutes: Int
    let cycles: Int
    let description: String
}

enum PomodoroMode: Equatable, Hashable {
    case preset(PomodoroPreset)
    case custom(CustomConfig)
}

struct CustomConfig: Equatable, Codable, Hashable {
    var title: String = "Mode Kustom"
    var focusMinutes: Int
    var breakMinutes: Int
    var cycles: Int
}

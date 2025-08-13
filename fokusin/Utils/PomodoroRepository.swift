//
//  PomodoroRepository.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 08/08/25.
//

import Foundation

final class PomodoroRepository: ObservableObject {
    @Published var presets: [PomodoroPreset] = PomodoroData.presets
    @Published var defaults: PomodoroPresetFile.Defaults = PomodoroData.defaults
    
    private let customKey = "custom_pomodoro_config"

    func loadCustom() -> CustomConfig? {
        guard let data = UserDefaults.standard.data(forKey: customKey) else { return nil }
        return try? JSONDecoder().decode(CustomConfig.self, from: data)
    }
    func saveCustom(_ config: CustomConfig) {
        if let data = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(data, forKey: customKey)
        }
    }
}


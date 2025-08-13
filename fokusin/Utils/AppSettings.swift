//
//  AppSettings.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 11/08/25.
//

import Foundation
import SwiftData

@Model
final class AppSettings {
    @Attribute(.unique) var key: String = "settings_singleton"
    var selectedSkinID: String

    init(selectedSkinID: String = "charnest2") {
        self.selectedSkinID = selectedSkinID
    }
}

@MainActor
struct SkinManager {
    let ctx: ModelContext

    // Ambil/bikin settings
    private func settings() throws -> AppSettings {
        let p = #Predicate<AppSettings> { $0.key == "settings_singleton" }
        var fd = FetchDescriptor<AppSettings>(predicate: p)
        fd.fetchLimit = 1
        if let s = try ctx.fetch(fd).first { return s }
        let s = AppSettings()
        ctx.insert(s)
        try ctx.save()
        return s
    }

    // Skin yang sedang dipakai (kalau locked, fallback ke terbaik yang unlocked)
    func currentSkin(totalMinutes: Int) throws -> CharacterSkin {
        let s = try settings()
        if let chosen = CharacterSkins.withID(s.selectedSkinID),
           totalMinutes >= chosen.requiredMinutes {
            return chosen
        }
        return CharacterSkins.bestUnlocked(for: totalMinutes)
    }

    // Coba ganti skin. Return true kalau berhasil (unlocked), false kalau masih terkunci
    @discardableResult
    func select(skinID: String, totalMinutes: Int) throws -> Bool {
        guard let skin = CharacterSkins.withID(skinID) else { return false }
        guard totalMinutes >= skin.requiredMinutes else { return false }
        let s = try settings()
        s.selectedSkinID = skinID
        try ctx.save()
        return true
    }

    // Daftar yang sudah kebuka
    func unlockedSkins(totalMinutes: Int) -> [CharacterSkin] {
        CharacterSkins.all.filter { totalMinutes >= $0.requiredMinutes }
    }
}


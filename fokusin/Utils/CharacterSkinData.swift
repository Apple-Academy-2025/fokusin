//
//  CharacterSkinData.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 11/08/25.
//

import Foundation

struct CharacterSkin: Identifiable, Equatable {
    let id: String           // "charnest1"
    let assetName: String    // "CharNest1" (nama di Assets)
    let requiredMinutes: Int // syarat total fokus (menit)

    var displayName: String {
        switch id {
        case "charnest1": return "Charnest 1"
        case "charnest2": return "Charnest 2"
        default: return id.capitalized
        }
    }
}

enum CharacterSkins {
    /// Tambah item baru di sini kalau ada aset baru
    static let all: [CharacterSkin] = [
        .init(id: "charnest1", assetName: "CharNest1", requiredMinutes: 0),        // default
        .init(id: "charnest2", assetName: "CharNest2", requiredMinutes: 5 * 60),   // > 5 jam
        // contoh nanti:
        // .init(id: "charnest3", assetName: "CharNest3", requiredMinutes: 10 * 60),
    ]

    static func bestUnlocked(for totalMinutes: Int) -> CharacterSkin {
        // pilih skin dengan syarat <= totalMinutes, ambil yang syaratnya paling tinggi
        return all
            .filter { totalMinutes >= $0.requiredMinutes }
            .max(by: { $0.requiredMinutes < $1.requiredMinutes })
        ?? all[0]
    }

    static func withID(_ id: String) -> CharacterSkin? {
        all.first { $0.id == id }
    }
}

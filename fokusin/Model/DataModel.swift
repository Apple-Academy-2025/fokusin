//
//  DataModel.swift
//  fokusin
//
//  Created by Muhamad Alif Anwar on 19/03/25.
//

import Foundation

struct DifficultyMode: Identifiable {
    let id: Int
    let difficulty: String
    let title: String
    let description: String
    let time: (focus: Int, rest: Int, section: Int)
    let detail: [String]
}

//
//  Theme.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import Foundation

struct Theme: Identifiable {
    var title: String
    var emojis: String
    var numberOfPairs: Int
    var colorHex: String
    var id: UUID = UUID()
    
#warning("make emoji count different for each theme")
    
    static var builtins: [Theme] = [
        Theme(title: "Nature",
              emojis: "🌸☀️🌳💫🌲🍀🌊☔️🐳🐸",
              colorHex: "#34C759"),
        Theme(title: "Office",
              emojis: "🖊️📌📒📊✂️📐✏️📤📎💼",
              colorHex: "#000000"),
        Theme(title: "Fashion",
              emojis: "👑🧣👚🩳🧦🧢👗👖🩱👔",
              colorHex: "#AF52DE"),
        Theme(title: "Party",
              emojis: "🎉🎈🧁🥳🍾🎁🪅🎂🪩👏🏼",
              colorHex: "#FF2D55"),
        Theme(title: "Sports",
              emojis: "🏓🥊🏇🏼🚴🏻‍♀️🏂🏀🏋🏻‍♀️🏐🏄🏻‍♀️⛳️",
              colorHex: "#FF9500"),
        Theme(title: "Transportation",
              emojis: "🚙🚜🚲🚠✈️🚂🚁🚤🚢🚀",
              colorHex: "#007AFF")
    ]
    
    static private let minPairsOfCards: Int = 4
    
    init(title: String, emojis: String, colorHex: String) {
        self.title = title
        self.emojis = emojis
        self.numberOfPairs = Int.random(in: Self.minPairsOfCards...emojis.count)
        self.colorHex = colorHex
    }
}

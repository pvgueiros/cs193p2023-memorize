//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 16/10/24.
//

import Foundation

struct EmojiMemoryGameTheme {
    
    static private(set) var themes: [EmojiMemoryGameTheme] = [
        EmojiMemoryGameTheme(
            title: "Nature",
            emojis: ["🌸", "☀️", "🌳", "💫", "🌲", "🍀", "🌊", "☔️", "🐳", "🐸"],
            color: "green"),
        EmojiMemoryGameTheme(
            title: "Office",
            emojis: ["🖊️", "📌", "📒", "📊", "✂️", "📐", "✏️", "📤", "📎", "💼"],
            color: "black"),
        EmojiMemoryGameTheme(
            title: "Fashion",
            emojis: ["👑", "🧣", "👚", "🩳", "🧦", "🧢", "👗", "👖", "🩱", "👔"],
            color: "purple"),
        EmojiMemoryGameTheme(
            title: "Party",
            emojis: ["🎉", "🎈", "🧁", "🥳", "🍾", "🎁", "🪅", "🎂", "🪩", "👏🏼"],
            color: "pink"),
        EmojiMemoryGameTheme(
            title: "Sports",
            emojis: ["🏓", "🥊", "🏇🏼", "🚴🏻‍♀️", "🏂", "🏀", "🏋🏻‍♀️", "🏐", "🏄🏻‍♀️", "⛳️"],
            color: "orange"),
        EmojiMemoryGameTheme(
            title: "Transportation",
            emojis: ["🚙", "🚜", "🚲", "🚠", "✈️", "🚂", "🚁", "🚤", "🚢", "🚀"],
            color: "blue")
    ]
    
    static func add(theme: EmojiMemoryGameTheme) {
        themes.append(theme)
    }
    
    static private let minPairsOfCards: Int = 4
    
    let title: String
    let emojis: [String]
    let numberOfPairs: Int
    let colorName: String
    
    init(title: String, emojis: [String], color: String) {
        self.title = title
        self.emojis = emojis
        self.numberOfPairs = Int.random(in: Self.minPairsOfCards ... emojis.count)
        self.colorName = color
    }
}

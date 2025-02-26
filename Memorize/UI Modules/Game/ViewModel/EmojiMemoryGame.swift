//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 09/10/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    @Published private(set) var theme = EmojiMemoryGameTheme.themes.first!
    @Published private var game = MemoryGame<String>()
    
    private let colorForString: [String: Color] = [
        "green": .green,
        "black": .black,
        "purple": .purple,
        "pink": .pink,
        "orange": .orange,
        "blue": .blue
    ]
    
    init() {
        createNewGame()
    }
    
    var cards: Array<Card> {
        game.cards
    }
    
    var score: Int {
        game.score
    }
    
    var themeColor: Color {
        colorForString[theme.colorName] ?? .pink
    }
    
    var themeTitle: String {
        theme.title
    }
    
    // MARK: - Intents
    
    func createNewGame() {
        guard let randomTheme = EmojiMemoryGameTheme.themes.randomElement() else { return }
        let shuffledEmojis = randomTheme.emojis.shuffled()
        
        self.game = MemoryGame(numberOfPairsOfCards: randomTheme.numberOfPairs) { pairIndex in
            if shuffledEmojis.indices.contains(pairIndex) {
                return shuffledEmojis[pairIndex]
            } else {
                return "❓"
            }
        }
        self.theme = randomTheme
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
}

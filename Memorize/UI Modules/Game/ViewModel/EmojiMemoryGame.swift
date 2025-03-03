//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 09/10/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private(set) var theme: Theme
    @Published private var game = MemoryGame<String>()
    
    init(_ theme: Theme) {
        self.theme = theme
        createNewGame()
    }
    
    var cards: Array<Card> {
        game.cards
    }
    
    var score: Int {
        game.score
    }
    
    var themeTitle: String {
        theme.title
    }
    
    // MARK: - Intents
    
    func createNewGame() {
        let shuffledEmojis = theme.emojis.uniqued.map(String.init).shuffled()
        
        self.game = MemoryGame(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            if shuffledEmojis.indices.contains(pairIndex) {
                return shuffledEmojis[pairIndex]
            } else {
                return "❓"
            }
        }
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
}

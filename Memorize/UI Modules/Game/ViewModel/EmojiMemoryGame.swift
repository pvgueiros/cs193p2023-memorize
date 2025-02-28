//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 09/10/24.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    var themePresenter: ThemePresenter
    @Published private var game = MemoryGame<String>()
    
    init(themePresenter: ThemePresenter) {
        self.themePresenter = themePresenter
        createNewGame()
    }
    
    var cards: Array<Card> {
        game.cards
    }
    
    var score: Int {
        game.score
    }
    
    var themeTitle: String {
        themePresenter.title
    }
    
    var themeColor: Color {
        themePresenter.color
    }
    
    // MARK: - Intents
    
    func createNewGame() {
        let shuffledEmojis = themePresenter.theme.emojis.uniqued.map(String.init).shuffled()
        
        self.game = MemoryGame(numberOfPairsOfCards: themePresenter.theme.numberOfPairs) { pairIndex in
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

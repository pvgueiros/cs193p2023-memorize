//
//  MemoryGame.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 09/10/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var score: Int = 0
    
    init() {
        cards = []
        score = 0
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        self.init()
        
        for pairIndex in 0 ..< max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
    }
    
    private var indexOfOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp == true }.singleElement }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialIndex = indexOfOnlyFaceUpCard {
                    if cards[potentialIndex].content == cards[chosenIndex].content {
                        cards[potentialIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                        
                        updateScore(by: 2)
                    } else { // mismatch
                        if cards[chosenIndex].hasBeenSeen { updateScore(by: -1) }
                        if cards[potentialIndex].hasBeenSeen { updateScore(by: -1) }
                        
                        cards[chosenIndex].hasBeenSeen = true
                        cards[potentialIndex].hasBeenSeen = true
                    }
                } else {
                    indexOfOnlyFaceUpCard = chosenIndex
                }
                
                cards[chosenIndex].isFaceUp = true
            }
        }
    }
    
    mutating private func updateScore(by offset: Int) {
        score += offset
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp = false
        var isMatched = false
        var hasBeenSeen = false
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}

extension Array {
    var singleElement: Element? {
        self.count == 1 ? self.first : nil
    }
}

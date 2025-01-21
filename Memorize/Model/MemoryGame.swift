//
//  MemoryGame.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 09/10/24.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    struct Constant {
        struct Score {
            static var match: Int { 2 }
            static var mismatch: Int { -1 }
        }
    }
    
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
            let cardID = UUID().uuidString
            cards.append(Card(content: content, id: "\(cardID)a"))
            cards.append(Card(content: content, id: "\(cardID)b"))
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
                        
                        updateScore(by: Constant.Score.match + cards[chosenIndex].bonus + cards[potentialIndex].bonus)
                    } else { // mismatch
                        if cards[chosenIndex].hasBeenSeen { updateScore(by: Constant.Score.mismatch) }
                        if cards[potentialIndex].hasBeenSeen { updateScore(by: Constant.Score.mismatch) }
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
        var isFaceUp = false {
            didSet {
                if isFaceUp { startUsingBonusTime() }
                else { stopUsingBonusTime() }
                
                if oldValue && !isFaceUp {
                    hasBeenSeen = true
                }
            }
        }
        
        var isMatched = false {
            didSet {
                if isMatched { stopUsingBonusTime() }
            }
        }
        
        var hasBeenSeen = false
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
        
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}

extension Array {
    var singleElement: Element? {
        self.count == 1 ? self.first : nil
    }
}

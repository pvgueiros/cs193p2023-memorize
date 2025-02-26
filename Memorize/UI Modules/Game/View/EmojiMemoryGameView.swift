//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 07/10/24.
//

import SwiftUI

///
/// ": View" means "behaves like a view" - not it's superclass! Means it conforms to the protocol View
/// Functional programming is about behavior
///
struct EmojiMemoryGameView: View {
    
    typealias Card = MemoryGame<String>.Card
    
    private struct Constant {
        static let aspectRatio: CGFloat = 2/3
        static let inset: CGFloat = 4
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
        static let deckWidth: CGFloat = 50
        
        struct Font {
            static let title: CGFloat = 28
            static let score: CGFloat = 18
            static let newGameButton: CGFloat = 16
        }
        
        struct Animation {
            static let delay: TimeInterval = 0.1
        }
    }
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Theme: \(viewModel.themeTitle)")
                .font(.system(size: Constant.Font.title))
            cards
            footer
        }
        .foregroundStyle(viewModel.themeColor)
        .padding()
    }
    
    @Namespace private var dealingAnimation
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constant.aspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingAnimation)
                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
                    .padding(Constant.inset)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card)
                    }
            }
        }
    }
    
    private func choose(_ card: Card) {
        let scoreBeforeSelection = viewModel.score
        withAnimation {
            viewModel.choose(card)
        }
        let scoreChange = viewModel.score - scoreBeforeSelection
        lastScoreChange = (scoreChange, causedByCardID: card.id)
    }
    
    @State private var lastScoreChange = (0, causedByCardID: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (scoreChangeAmount, scoreChangeCardID) = lastScoreChange
        return scoreChangeCardID == card.id ? scoreChangeAmount : 0
    }
    
    private var footer: some View {
        HStack {
            scoreView.frame(maxWidth: .infinity, alignment: .leading)
            deckView.frame(maxWidth: .infinity, alignment: .center)
            newGameButton.frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(Constant.inset)
    }
    
    private var scoreView: some View {
        Text("Score: \(viewModel.score)")
            .font(.system(size: Constant.Font.score))
            .animation(nil)
    }
    
    private var deckView: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingAnimation)
                
                    /// the line of code below doesn't override matched geometry, but not adding it corresponds to having ".transition(.identity)", which does!
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constant.deckWidth, height: Constant.deckWidth / Constant.aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in viewModel.cards {
            withAnimation(.easeInOut.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += Constant.Animation.delay
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    private var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                viewModel.createNewGame()
            }
        }
        .font(.system(size: Constant.Font.newGameButton))
        .padding()
        .cornerRadius(Constant.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Constant.cornerRadius)
            .stroke(viewModel.themeColor, lineWidth: Constant.lineWidth))
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}

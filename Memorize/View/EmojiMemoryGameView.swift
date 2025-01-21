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
        static let lineWidth: CGFloat = 3
    }
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("Theme: \(viewModel.themeTitle)")
                .font(.title)
            cards
            footer
        }
        .foregroundStyle(viewModel.themeColor)
        .padding()
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constant.aspectRatio) { card in
            CardView(card)
                .padding(Constant.inset)
                .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        return 0
    }
    
    var footer: some View {
        HStack {
            score
            Spacer()
            newGameButton
        }
        .padding(Constant.inset)
        .font(.title2)
    }
    
    var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                viewModel.createNewGame()
            }
        }
        .padding()
        .cornerRadius(Constant.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: Constant.cornerRadius)
            .stroke(viewModel.themeColor, lineWidth: Constant.lineWidth))
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}

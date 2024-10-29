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
                .animation(.default, value: viewModel.cards)
            footerView
        }
        .foregroundStyle(viewModel.themeColor)
        .padding()
    }
    
    var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constant.aspectRatio) { card in
            CardView(card)
                .padding(Constant.inset)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
    
    var footerView: some View {
        HStack {
            Text("Score: \(viewModel.score)")
            Spacer()
            Button("New Game") {
                viewModel.createNewGame()
            }
            .padding()
            .cornerRadius(Constant.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .stroke(viewModel.themeColor, lineWidth: Constant.lineWidth))
        }
        .padding(Constant.inset)
        .font(.title2)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}

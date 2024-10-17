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
    let themes: [EmojiMemoryGameTheme] = [.nature, .office, .fashion]
    @State var theme: EmojiMemoryGameTheme = .nature
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Memorize!")
                    .font(.system(size: 32))
                cards
            }
            .foregroundStyle(theme.color)
            .padding()
            Button("Shuffle") {
                viewModel.shuffle()
            }
            themeButtonArea
        }
    }
    
    var cards: some View {
        let numberOfPairs = Int.random(in: 4...theme.emojis.count)
        var emojisComplete = Array(theme.emojis[0..<numberOfPairs])
        emojisComplete = (emojisComplete + emojisComplete).shuffled()
        
        let columns = [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: emojisComplete.count), maximum: widthThatBestFits(cardCount: emojisComplete.count)), spacing: 0)]
        
        return LazyVGrid(columns: columns, spacing: 0) {
            ForEach(emojisComplete.indices, id: \.self) { index in
                CardView(viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
            }
        }
    }
    
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        UIScreen.main.bounds.width / (ceil(sqrt(CGFloat(cardCount))) + 1)
    }
    
    var themeButtonArea: some View {
        HStack (alignment: .bottom) {
            ForEach(themes.indices, id: \.self) { index in
                themeButton(for: themes[index])
            }
            .padding()
        }
    }
    
    func themeButton(for theme: EmojiMemoryGameTheme) -> some View {
        Button {
            self.theme = theme
        } label: {
            VStack {
                Image(systemName: theme.buttonImageName).imageScale(.large)
                Text(theme.buttonTitle).font(.caption)
            }
        }
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let baseRectangle = RoundedRectangle(cornerRadius: 10)
            
            baseRectangle.fill()
                .opacity(card.isFaceUp ? 0 : 1)
            Group {
                baseRectangle.fill(.white)
                baseRectangle.strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
        }
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}

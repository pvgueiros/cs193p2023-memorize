//
//  ContentView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 07/10/24.
//

import SwiftUI

///
/// ": View" means "behaves like a view" - not it's superclass! Means it conforms to the protocol View
/// Functional programming is about behavior
///
struct ContentView: View {
    let emojis = ["👑", "💂🏻‍♂️", "💎", "👑", "🥰", "🪙", "👣", "🧠", "👗", "👜", "👠", "🐸"]
    @State var cardCount = 4
    
    var body: some View {
        VStack {
            ScrollView {
                cards
            }
            Spacer()
            cardCountAjusters
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.blue)
    }
    
    var cardCountAjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "rectangle.stack.fill.badge.minus")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "rectangle.stack.fill.badge.plus")
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button {
            cardCount += offset
        } label: {
            Image(systemName: symbol)
        }
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let baseShape = RoundedRectangle(cornerRadius: 20)
            Group {
                baseShape.fill(.white)
                baseShape.strokeBorder(lineWidth: 5)
                Text("👑").font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            baseShape.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}

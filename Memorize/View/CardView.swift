//
//  CardView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 24/10/24.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemoryGame<String>.Card
    
    private struct Constant {
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        struct Pie {
            static let opacity: Double = 0.3
        }
    }
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(140))
            .opacity(Constant.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constant.FontSize.largest))
                    .minimumScaleFactor(Constant.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constant.inset)
            )
            .padding(Constant.inset)
            .cardify(isFaceUp: card.isFaceUp)
            .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    CardView(CardView.Card(isFaceUp: true, content: "🏄🏻‍♀️", id: "sample1"))
        .padding()
}

//struct CardView_Previews: PreviewProvider {
//    typealias Card = CardView.Card
//    static var previews: some View {
//        CardView(Card(isFaceUp: true, content: "🏄🏻‍♀️", id: "sample1"))
//            .padding()
//    }
//}

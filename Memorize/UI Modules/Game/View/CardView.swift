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
        
        struct Rotation {
            static let initialAngle: Double = 0
            static let finalAngle: Double = 360
            static let duration: Double = 1
        }
    }
    
    let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            if card.isFaceUp || !card.isMatched {
                pieView
                    .overlay(
                        contentView
                            .padding(Constant.inset)
                    )
                    .padding(Constant.inset)
                    .cardify(isFaceUp: card.isFaceUp)
                    .transition(.scale)
            } else {
                Color.clear
            }
        }
    }
    
    var pieView: some View {
        Pie(endAngle: .degrees(-card.bonusPercentRemaining * 360))
            .opacity(Constant.Pie.opacity)
    }
    
    var contentView: some View {
        Text(card.content)
            .font(.system(size: Constant.FontSize.largest))
            .minimumScaleFactor(Constant.FontSize.scaleFactor)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched
                                     ? Constant.Rotation.finalAngle
                                     : Constant.Rotation.initialAngle))
            .animation(.spin(duration: Constant.Rotation.duration), value: card.isMatched)
    }
}

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
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

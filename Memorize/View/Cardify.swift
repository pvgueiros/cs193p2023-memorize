//
//  Cardify.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 24/10/24.
//

import SwiftUI

struct Cardify: ViewModifier {
    private struct Constant {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
    
    let isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let baseRectangle = RoundedRectangle(cornerRadius: Constant.cornerRadius)
            
            /// this line first because it controlls the size of the card
            baseRectangle.strokeBorder(lineWidth: Constant.lineWidth)
                .background(baseRectangle.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            baseRectangle.fill()
                .opacity(isFaceUp ? 0 : 1)
        }
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp))
    }
}

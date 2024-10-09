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
    let emojis = ["👑", "🪙", "💂🏻‍♂️", "💎"]
    
    var body: some View {
        HStack {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
            }
        }
        .foregroundColor(.blue)
        .padding()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let baseShape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                baseShape.fill(.white)
                baseShape.strokeBorder(lineWidth: 5)
                Text("👑")
                    .font(.largeTitle)
            } else {
                baseShape.fill()
            }
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}

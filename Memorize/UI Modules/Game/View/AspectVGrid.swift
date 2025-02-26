//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 22/10/24.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let aspectRatio: CGFloat
    let content: (Item) -> ItemView
    
    init(_ cards: [Item], aspectRatio: CGFloat, @ViewBuilder cardBuilder: @escaping (Item) -> ItemView) {
        self.items = cards
        self.aspectRatio = aspectRatio
        self.content = cardBuilder
    }
    
    var body: some View {
        GeometryReader { geometry in
            let itemWidth = gridItemWidthThatFits(
                in: geometry.size,
                numberOfItems: items.count,
                aspectRatio: aspectRatio)
            
            let columns = [GridItem(.adaptive(minimum: itemWidth),
                                    spacing: 0)]
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(items) { card in
                    content(card)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    func gridItemWidthThatFits(in size: CGSize, numberOfItems: Int, aspectRatio: CGFloat) -> CGFloat {
        var numberOfColumns: CGFloat = 1.0
        let numberOfItems = CGFloat(numberOfItems)
        
        repeat {
            let itemWidth = size.width / numberOfColumns
            let itemHeight = itemWidth / aspectRatio
            let numberOfRows = (numberOfItems / numberOfColumns).rounded(.up)
            
            if numberOfRows * itemHeight <= size.height {
                return (size.width / numberOfColumns).rounded(.down)
            }
            numberOfColumns += 1
        } while numberOfColumns < numberOfItems
        
        return min(size.width / numberOfItems, size.height * aspectRatio).rounded(.down)
    }
}

#Preview {
    let cards = [
        MemoryGame.Card(isFaceUp: true, content: "🏄🏻‍♀️", id: "sample1"),
        MemoryGame.Card(isFaceUp: true, content: "My super duper ultra large text as a content", id: "sample2")
    ]
    
    AspectVGrid(cards, aspectRatio: 2/3) { card in
        CardView(card)
            .padding()
    }
}

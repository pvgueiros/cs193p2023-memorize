//
//  ThemeListView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import SwiftUI

struct ThemeListView: View {
    private let listItemSpacing: CGFloat = 5
    
    @EnvironmentObject var store: ThemeStore
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(store.themePresenters) { themePresenter in
                    NavigationLink(value: themePresenter.theme) {
                        VStack(alignment: .leading, spacing: listItemSpacing) {
                            Text(themePresenter.title)
                                .font(.title)
                                .foregroundStyle(themePresenter.color)
                            Text(themePresenter.subtitle)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .navigationDestination(for: Theme.self) { theme in
                let gameViewModel = EmojiMemoryGame(themePresenter: ThemePresenter(theme: theme))
                EmojiMemoryGameView(viewModel: gameViewModel)
            }
        } detail: {
            
        }
    }
}

//#Preview {
//    ThemeListView()
//}

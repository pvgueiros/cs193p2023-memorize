//
//  ThemeListView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import SwiftUI

struct ThemeListView: View {
    private let listItemSpacing: CGFloat = 5
    
    @ObservedObject var store: ThemeStore
    @State var showThemeView: Bool = false
    @State var selectedThemeId: Theme.ID?
    
    // TODO: - separate views into smaller vars/funcs
    
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
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            selectedThemeId = themePresenter.id
                            print("Selected theme id: " + (selectedThemeId?.uuidString ?? "nil"))
                            showThemeView = true
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { indexSet in
                    store.themePresenters.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, offset in
                    store.themePresenters.move(fromOffsets: indexSet, toOffset: offset)
                }
                
            }
//            .toolbar {
//                Button {
//                    // add theme
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
            .navigationDestination(for: Theme.self) { theme in
                let gameViewModel = EmojiMemoryGame(themePresenter: ThemePresenter(theme: theme))
                EmojiMemoryGameView(viewModel: gameViewModel)
            }
            .sheet(isPresented: $showThemeView) {
                if let selectedThemeId, let index = store.indexOfThemePresenter(withId: selectedThemeId) {
                    ThemeView(presenter: $store.themePresenters[index])
                }
            }
            .navigationTitle("Theme List")
        } detail: { }
    }
    
}

//#Preview {
//    ThemeListView()
//}

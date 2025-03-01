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
    @State private var selectedThemePresenter: ThemePresenter? {
        didSet {
            showThemeView = selectedThemePresenter != nil
        }
    }
    
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
                            selectedThemePresenter = themePresenter
                            print("Selected theme: \(selectedThemePresenter?.title ?? "nil")")
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
//                    // delect added theme
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
            .navigationDestination(for: Theme.self) { theme in
                let gameViewModel = EmojiMemoryGame(themePresenter: ThemePresenter(theme: theme))
                EmojiMemoryGameView(viewModel: gameViewModel)
            }
            .sheet(item: $selectedThemePresenter) { themePresenter in
                if let index = store.indexOf(themePresenter: themePresenter) {
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

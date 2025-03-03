//
//  ThemeListView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

// TODO: - separate views into smaller vars/funcs
// TODO: - add access control
// TODO: - add section marks
// TODO: - review constants
// TODO: - consider changing selectedTheme to selectedThemeId
// TODO: - consider switching to List(selection:
// TODO: - add message when no selection

import SwiftUI

struct ThemeListView: View {
    private let listItemSpacing: CGFloat = 5
    
    @EnvironmentObject var store: ThemeStore
    @State var showThemeView: Bool = false
    @State private var selectedTheme: Theme? {
        didSet {
            showThemeView = selectedTheme != nil
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(value: theme) {
                        VStack(alignment: .leading, spacing: listItemSpacing) {
                            Text(store.titleFor(theme))
                                .font(.title)
                                .foregroundStyle(store.colorFor(theme))
                            Text(store.subtitleFor(theme))
                                .lineLimit(1)
                        }
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            selectedTheme = theme
                        } label: {
                            Image(systemName: "info.circle.fill")
                        }
                        .tint(.blue)
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, offset in
                    store.themes.move(fromOffsets: indexSet, toOffset: offset)
                }
                
            }
            .toolbar {
                Button {
                    selectedTheme = store.addTheme()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationDestination(for: Theme.self) { theme in
                let gameViewModel = EmojiMemoryGame(theme)
                EmojiMemoryGameView(viewModel: gameViewModel)
            }
            .sheet(item: $selectedTheme) { theme in
                if let index = store.indexOf(theme) {
                    ThemeView(theme: $store.themes[index])
                }
            }
            .navigationTitle("Theme List")
        } detail: { }
    }
}

//#Preview {
//    ThemeListView()
//}

//
//  ThemeListView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import SwiftUI

struct ThemeListView: View {
    
    // MARK: - General Properties
    
    @EnvironmentObject var store: ThemeStore
    
    @State private var showThemeView: Bool = false
    @State private var selectedThemeIdToPlay: Theme.ID?
    @State private var selectedThemeToEdit: Theme? {
        didSet {
            showThemeView = selectedThemeToEdit != nil
        }
    }
    
    // MARK: - UI Body
    
    var body: some View {
        NavigationSplitView {
            themeListView
        } detail: {
            detailView
        }
    }
    
    private var themeListView: some View {
        themeList
            .navigationTitle(Constant.Text.title)
            .toolbar { addThemeButton }
            .sheet(item: $selectedThemeToEdit) { theme in
                themeView(for: theme)
            }
    }
    
    private var themeList: some View {
        List(selection: $selectedThemeIdToPlay) {
            ForEach(store.themes) { theme in
                view(for: theme)
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    editButton(for: theme)
                }
            }
            .onDelete { indexSet in
                store.themes.remove(atOffsets: indexSet)
            }
            .onMove { indexSet, offset in
                store.themes.move(fromOffsets: indexSet, toOffset: offset)
            }
        }
    }
    
    private func view(for theme: Theme) -> some View {
        VStack(alignment: .leading, spacing: Constant.listItemSpacing) {
            Text(store.titleFor(theme))
                .font(.title)
                .foregroundStyle(store.colorFor(theme))
            Text(store.subtitleFor(theme))
                .lineLimit(1)
        }
        .tag(theme.id)
    }
    
    private var addThemeButton: some View {
        Button {
            selectedThemeToEdit = store.addTheme()
        } label: {
            Image(systemName: Constant.ImageName.addTheme)
        }
    }
    
    private func editButton(for theme: Theme) -> some View {
        Button {
            selectedThemeToEdit = theme
        } label: {
            Image(systemName: Constant.ImageName.editTheme)
        }
        .tint(.blue)
    }
    
    // MARK: - Navigation
    
    @ViewBuilder
    private var detailView: some View {
        if let selectedThemeIdToPlay,
           let selectedThemeToPlay = store.themes.first(where: { $0.id == selectedThemeIdToPlay }) {
            memorizeGame(for: selectedThemeToPlay)
        } else {
            startStateView
        }
    }
    
    private func memorizeGame(for theme: Theme) -> some View {
        let gameViewModel = EmojiMemoryGame(theme)
        return EmojiMemoryGameView(viewModel: gameViewModel)
    }
    
    private var startStateView: some View {
        Text(Constant.Text.startStateMessage)
    }
    
    @ViewBuilder
    private func themeView(for theme: Theme) -> some View {
        if let index = store.indexOf(theme) {
            ThemeView(theme: $store.themes[index])
        }
    }
    
    // MARK: - Constants
    
    struct Constant {
        static let listItemSpacing: CGFloat = 5
        
        struct Text {
            static let title: String = "Themes"
            static let startStateMessage: String = "Tap on the upper left corner icon to choose a theme"
        }
        
        struct ImageName {
            static let addTheme: String = "plus"
            static let editTheme: String = "info.circle.fill"
        }
    }
}

#Preview {
    ThemeListView()
        .environmentObject(ThemeStore())
}

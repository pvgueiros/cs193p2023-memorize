//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

import SwiftUI

struct ThemeView: View {
    
    // MARK: - General Properties
    
    @EnvironmentObject var store: ThemeStore
    @Binding var theme: Theme
    @State private var selectedColor: Color = Color.black

    enum Focused {
        case title
        case newEmojis
    }
    @FocusState private var focused: Focused?
    
    // MARK: - Body Root
    
    var body: some View {
        Form {
            titleSection
            emojiSection
            sizeSection
            trashSection
        }
        .onAppear {
            if theme.title.isEmpty { focused = .title }
            selectedColor = store.colorFor(theme)
        }
        .onChange(of: theme.emojis.count) { _, _ in
            theme.numberOfPairs = min(theme.numberOfPairs, theme.emojis.count)
        }
    }
    
    // MARK: - Title
    
    private var titleSection: some View {
        Section(Constant.Text.title) {
            HStack {
                TextField(Constant.Text.themeTitle, text: $theme.title)
                    .font(Constant.Size.defaultFont)
                    .foregroundStyle(store.colorFor(theme))
                    .focused($focused, equals: .title)
                    .layoutPriority(1)
                ColorPicker("", selection: $selectedColor)
                    .onChange(of: selectedColor) { oldValue, newValue in
                        store.setColor(selectedColor, for: theme)
                    }
            }
        }
    }
    
    // MARK: - Active Emoji
    
    private var emojiSection: some View {
        Section(header: emojiSectionHeader) {
            currentEmojisView
            newEmojisView
        }
    }
    
    private var emojiSectionHeader: some View {
        HStack {
            Text(Constant.Text.emojiSectionTitle)
            Spacer()
            Text(Constant.Text.emojiSectionSubtitle)
        }
    }
    
    @State private var showMinimumSetSizeReached: Bool = false
    
    private var currentEmojisView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: Constant.Size.emojiGrid))]) {
            let emojiArray = theme.emojis.uniqued.map(String.init)
            ForEach(emojiArray, id: \.self) { emoji in
                Text(emoji)
                    .font(Constant.Size.defaultFont)
                    .onTapGesture {
                        removeEmoji(emoji)
                    }
            }
        }
        .simpleAlert(Constant.Text.minimumSetSizeReachedTitle,
                     isPresented: $showMinimumSetSizeReached,
                     message: Constant.Text.minimumSetSizeReachedMessage)
    }
    
    private func removeEmoji(_ emoji: String) {
        guard store.canRemoveEmoji(from: theme) else {
            showMinimumSetSizeReached = true
            return
        }
        
        if let emojiChar = emoji.first {
            newEmojis.removeAll(emojiChar)
            theme.emojis.removeAll(emojiChar)
            theme.removedEmojis = (theme.removedEmojis + [emojiChar]).uniqued
        }
    }
    
    @State private var newEmojis: String = ""
    
    private var newEmojisView: some View {
        TextField(Constant.Text.newEmojisPlaceholder, text: $newEmojis)
            .onChange(of: newEmojis) { oldValue, newValue in
                theme.emojis = (newValue + theme.emojis)
                    .filter { $0.isEmoji }
                    .uniqued
            }
            .focused($focused, equals: .newEmojis)
    }
    
    // MARK: - Size
    
    private var sizeSection: some View {
        Section(Constant.Text.sizeSectionTitle) {
            Stepper(value: $theme.numberOfPairs, in: store.emojiSetRange(for: theme)) {
                Text("\(theme.numberOfPairs) pairs")
            }
        }
    }
    
    // MARK: - Removed Content
    
    @ViewBuilder
    private var trashSection: some View {
        if theme.hasRemovedContent {
            Section(Constant.Text.trashSectionTitle) {
                removedEmojisView
                removedContentActions
            }
        }
    }
    
    private var removedEmojisView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: Constant.Size.emojiGrid))]) {
            let removedEmojiArray = theme.removedEmojis.uniqued.map(String.init)
            ForEach(removedEmojiArray, id: \.self) { emoji in
                Text(emoji)
                    .font(Constant.Size.defaultFont)
            }
        }
    }
    
    private var removedContentActions: some View {
        HStack {
            Button(Constant.Text.restoreButtonTitle) {
                theme.emojis = (theme.emojis + theme.removedEmojis).uniqued
                theme.removedEmojis = ""
            }
            Spacer()
            Button(Constant.Text.deleteButtonTitle, role: .destructive) {
                theme.removedEmojis = ""
            }
        }
        .buttonStyle(.borderless)
    }
    
    // MARK: - Constants
    
    struct Constant {
        struct Text {
            static let title: String = "Title"
            static let themeTitle: String = "Theme Title"
            
            static let newEmojisPlaceholder: String = "New Emoji"
            static let emojiSectionTitle: String = "Emoji Set"
            static let emojiSectionSubtitle: String = "Tap to Remove"
            
            static let sizeSectionTitle: String = "Size"
            
            static let trashSectionTitle: String = "Trash"
            static let restoreButtonTitle: String = "Restore content"
            static let deleteButtonTitle: String = "Delete forever"

            static let minimumSetSizeReachedTitle: LocalizedStringKey = "Minimum set size reached"
            static let minimumSetSizeReachedMessage: String = "You must not have fewer than 4 pairs of emoji. Add more emoji before removing this one."
        }
        
        struct Size {
            static let emojiGrid: CGFloat = 35
            static let defaultFont: Font = .largeTitle
        }
    }
}

#Preview {
    @Previewable @State var theme = Theme(
        title: "Hello World",
        emojis: "🗺️🌎🌍🌏",
        colorRGBA: RGBA(red: 0/255, green: 200/255, blue: 100/255, alpha: 1)
    )
    
    ThemeView(theme: $theme)
        .environmentObject(ThemeStore())
}

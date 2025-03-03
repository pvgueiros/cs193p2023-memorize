//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

// TODO: - prevent theme from having less than 4 emojis

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
    
    // MARK: - UI Body
    
    var body: some View {
        Form {
            titleSection
            emojiSection
            sizeSection
        }
        .onAppear {
            if theme.title.isEmpty { focused = .title }
            selectedColor = store.colorFor(theme)
        }
        .onChange(of: theme.emojis.count) { _, _ in
            theme.numberOfPairs = min(theme.numberOfPairs, theme.emojis.count)
        }
    }
    
    private var titleSection: some View {
        Section(AppText.title) {
            HStack {
                TextField(AppText.themeTitle, text: $theme.title)
                    .font(Constant.Size.defaultFont)
                    .foregroundStyle(store.colorFor(theme))
                    .focused($focused, equals: .title)
                ColorPicker("", selection: $selectedColor)
                    .onChange(of: selectedColor) { oldValue, newValue in
                        store.setColor(selectedColor, for: theme)
                    }
            }
        }
    }
    
    private var emojiSection: some View {
        Section(header: emojiSectionHeader) {
            currentEmojiView
            newEmojisView
        }
    }
    
    private var emojiSectionHeader: some View {
        HStack {
            Text(AppText.emojiSectionTitle)
            Spacer()
            Text(AppText.emojiSectionSubtitle)
        }
    }
    
    @State private var showMinimumSetSizeReached: Bool = false
    
    private var currentEmojiView: some View {
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
        .simpleAlert(AppText.Error.minimumSetSizeReachedTitle,
                     isPresented: $showMinimumSetSizeReached,
                     message: AppText.Error.minimumSetSizeReachedMessage)
    }
    
    private func removeEmoji(_ emoji: String) {
        guard store.canRemoveEmoji(from: theme) else {
            showMinimumSetSizeReached = true
            return
        }
        
        theme.emojis.removeAll(emoji.first!)
        newEmojis.removeAll(emoji.first!)
    }
    
    @State private var newEmojis: String = ""
    
    private var newEmojisView: some View {
        TextField(AppText.newEmojisPlaceholder, text: $newEmojis)
            .onChange(of: newEmojis) { oldValue, newValue in
                theme.emojis = (newValue + theme.emojis)
                    .filter { $0.isEmoji }
                    .uniqued
            }
            .focused($focused, equals: .newEmojis)
    }
    
    private var sizeSection: some View {
        Section(AppText.sizeSectionTitle) {
            Stepper(value: $theme.numberOfPairs, in: Theme.minPairsOfCards...theme.emojis.count) {
                Text("\(theme.numberOfPairs) pairs")
            }
        }
    }
    
    // MARK: - Constants
    
    struct AppText {
        static let title: String = "Title"
        static let themeTitle: String = "Theme Title"
        static let newEmojisPlaceholder: String = "New Emoji"
        static let emojiSectionTitle: String = "Emoji Set"
        static let emojiSectionSubtitle: String = "Tap to Remove"
        static let sizeSectionTitle: String = "Size"
        
        struct Error {
            static let minimumSetSizeReachedTitle: LocalizedStringKey = "Minimum set size reached"
            static let minimumSetSizeReachedMessage: String = "You must not have fewer than 4 pairs of emoji. Add more emoji before removing this one."
        }
    }
    
    struct Constant {
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
}

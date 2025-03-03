//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

// TODO: - prevent theme from having less than 4 emojis
// TODO: - improve ColorPicker.onChange by using store

import SwiftUI

struct ThemeView: View {
    
    // MARK: - General Properties
    
    @EnvironmentObject var store: ThemeStore
    @Binding var theme: Theme
    @State private var selectedColor: Color = Color.black

    enum Focused {
        case title
        case newEmoji
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
        Section(Constant.Text.title) {
            HStack {
                TextField(Constant.Text.themeTitle, text: $theme.title)
                    .font(Constant.Size.defaultFont)
                    .foregroundStyle(store.colorFor(theme))
                    .focused($focused, equals: .title)
                ColorPicker("", selection: $selectedColor)
                    .onChange(of: selectedColor) { oldValue, newValue in
                        theme.colorRGBA = newValue.rgba
                    }
            }
        }
    }
    
    private var emojiSection: some View {
        Section(header: emojiSectionHeader) {
            currentEmojiView
            newEmojiView
        }
    }
    
    private var emojiSectionHeader: some View {
        HStack {
            Text(Constant.Text.emojiSectionTitle)
            Spacer()
            Text(Constant.Text.emojiSectionSubtitle)
        }
    }
    
    private var currentEmojiView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: Constant.Size.emojiGrid))]) {
            let emojiArray = theme.emojis.uniqued.map(String.init)
            ForEach(emojiArray, id: \.self) { emoji in
                Text(emoji)
                    .font(Constant.Size.defaultFont)
                    .onTapGesture {
                        theme.emojis.removeAll(emoji.first!)
                        newEmoji.removeAll(emoji.first!)
                    }
            }
        }
    }
    
    @State private var newEmoji: String = ""
    
    private var newEmojiView: some View {
        TextField(Constant.Text.newEmojiPlaceholder, text: $newEmoji)
            .onChange(of: newEmoji) { oldValue, newValue in
                theme.emojis = (newValue + theme.emojis)
                    .filter { $0.isEmoji }
                    .uniqued
            }
            .focused($focused, equals: .newEmoji)
    }
    
    private var sizeSection: some View {
        Section(Constant.Text.sizeSectionTitle) {
            Stepper(value: $theme.numberOfPairs, in: Theme.minPairsOfCards...theme.emojis.count) {
                Text("\(theme.numberOfPairs) pairs")
            }
        }
    }
    
    // MARK: - Constants
    
    struct Constant {
        struct Text {
            static let title: String = "Title"
            static let themeTitle: String = "Theme Title"
            static let newEmojiPlaceholder: String = "New Emoji"
            static let emojiSectionTitle: String = "Emoji Set"
            static let emojiSectionSubtitle: String = "Tap to Remove"
            static let sizeSectionTitle: String = "Size"
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
}

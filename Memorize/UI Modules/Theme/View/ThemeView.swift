//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

import SwiftUI

struct ThemeView: View {
    
    @EnvironmentObject var store: ThemeStore
    @Binding var theme: Theme
    
    @State private var newEmoji: String = ""
    @State private var pairsInStepper: Int = 2

    enum Focused {
        case title
        case newEmoji
    }
    @FocusState private var focused: Focused?
    
    // TODO: - separate body into smaller vara
    
    var body: some View {
        Form {
            Section(Constant.Text.title) {
                TextField(Constant.Text.themeTitle, text: $theme.title)
                    .font(Constant.Size.defaultFont)
                    .foregroundStyle(store.colorFor(theme))
                    .focused($focused, equals: .title)
                // add color picker
            }
            Section(header: HStack {
                Text(Constant.Text.emojiSectionTitle)
                Spacer()
                Text(Constant.Text.emojiSectionSubtitle)
            }) {
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
                TextField(Constant.Text.newEmojiPlaceholder, text: $newEmoji)
                    .onChange(of: newEmoji) { oldValue, newValue in
                        theme.emojis = (newValue + theme.emojis)
                            .filter { $0.isEmoji }
                            .uniqued
                    }
                    .focused($focused, equals: .newEmoji)
            }
            Section(Constant.Text.sizeSectionTitle) {
                Stepper(value: Binding(
                    get: { theme.numberOfPairs },
                    set: { newValue in
                        theme.numberOfPairs = min(newValue, theme.emojis.count)
                        pairsInStepper = theme.numberOfPairs
                    }
                ), in: Theme.minPairsOfCards...theme.emojis.count) {
                    Text("\(theme.numberOfPairs) pairs")
                }
            }
        }
        .onAppear {
            pairsInStepper = theme.numberOfPairs
            focused = theme.title.isEmpty ? .title : .newEmoji
        }
        .onChange(of: theme.numberOfPairs) { _, _ in
            theme.numberOfPairs = min(theme.numberOfPairs, theme.emojis.count)
            pairsInStepper = theme.numberOfPairs
        }
    }
    
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
        title: "World",
        emojis: "🗺️🌎🌍🌏",
        colorRGBA: RGBA(red: 0/255, green: 200/255, blue: 100/255, alpha: 1)
    )
    
    ThemeView(theme: $theme)
}

//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

import SwiftUI

struct ThemeView: View {
    
    @Binding var presenter: ThemePresenter
    @State private var newEmoji: String = ""

//    enum Focused {
//        case title
//        case newEmoji
//    }
//    @FocusState private var focused: Focused?
    
    var body: some View {
        Form {
            Section(Constant.Text.title) {
                TextField(Constant.Text.themeTitle, text: $presenter.theme.title)
                    .font(Constant.Size.defaultFont)
                    .foregroundStyle(presenter.color)
                // add color picker
            }
            Section(header: HStack {
                Text(Constant.Text.emojiSectionTitle)
                Spacer()
                Text(Constant.Text.emojiSectionSubtitle)
            }) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: Constant.Size.emojiGrid))]) {
                    let emojiArray = presenter.theme.emojis.uniqued.map(String.init)
                    ForEach(emojiArray, id: \.self) { emoji in
                        Text(emoji)
                            .font(Constant.Size.defaultFont)
                            .onTapGesture {
                                
                            }
                    }
                }
                TextField(Constant.Text.newEmojiPlaceholder, text: $newEmoji)
                    .onChange(of: newEmoji) { oldValue, newValue in
                        presenter.theme.emojis = (newValue + presenter.theme.emojis)
                            .filter { $0.isEmoji }
                            .uniqued
                        print("changing presenter.theme.emojis from \(oldValue) to \(newValue)")
                        print("presenter.theme.emojis == \(presenter.theme.emojis)")
                    }
            }
            Section(Constant.Text.sizeSectionTitle) {
                Text("\(presenter.theme.numberOfPairs) pairs")
                // add + / - buttons
            }
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
//
//#Preview {
//    @Previewable @State var presenter = ThemePresenter(theme:
//        Theme(
//            title: "World",
//            emojis: "🗺️🌎🌍🌏",
//            colorRGBA: RGBA(red: 0/255, green: 200/255, blue: 100/255, alpha: 1))
//    )
//    
//    ThemeView(presenter: $presenter)
//}

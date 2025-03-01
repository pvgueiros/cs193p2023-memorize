//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

import SwiftUI

struct ThemeView: View {
    
    @Binding var presenter: ThemePresenter
    
    enum Focused {
        case title
    }
    @FocusState private var focused: Focused?

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $presenter.theme.title)
                    .focused($focused, equals: .title)
            }
        }
    }
}

#Preview {
    @Previewable @State var previewThemePresenter = ThemePresenter(theme: Theme(title: "Hello World", emojis: "🗺️🌎🌍🌏", colorRGBA: RGBA(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)))
    
    ThemeView(presenter: $previewThemePresenter)
}

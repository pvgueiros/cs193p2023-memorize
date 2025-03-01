//
//  ThemeView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 28/02/25.
//

import SwiftUI

struct ThemeView: View {
    
    @Binding var presenter: ThemePresenter
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    @Previewable @State var previewThemePresenter = ThemePresenter(theme: Theme(title: "Hello World", emojis: "🗺️🌎🌍🌏", colorRGBA: RGBA(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)))
    
    ThemeView(presenter: $previewThemePresenter)
}

//
//  ThemeListView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import SwiftUI

struct ThemeListView: View {
    @ObservedObject var store: ThemeStore
    
    var body: some View {
        List {
            ForEach(store.themes) { theme in
                VStack(alignment: .leading) {
                    Text(theme.title)
                        .font(.largeTitle)
                        .foregroundStyle(Color(fromHex: theme.colorHex)) // replace, coming from viewmodel
                    Text(theme.emojis)
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    ThemeListView(store: ThemeStore())
}

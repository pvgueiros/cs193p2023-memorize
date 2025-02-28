//
//  ThemeStore.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import Foundation
import SwiftUI

class ThemeStore: ObservableObject {
    
    @Published private(set) var themePresenters: [ThemePresenter] = []
    
    init() {
        if themePresenters.isEmpty {
            let themes = Theme.builtins
            for theme in themes {
                themePresenters.append(ThemePresenter(theme: theme))
            }
        }
    }
    
    func presenter(for theme: Theme) -> ThemePresenter? {
        themePresenters.first(where: { $0.theme.id == theme.id })
    }
}

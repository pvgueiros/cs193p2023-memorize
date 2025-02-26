//
//  ThemeStore.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import Foundation
import SwiftUI

class ThemeStore: ObservableObject {
    
    @Published private(set) var themes: [Theme] = []
    
    init() {
        if themes.isEmpty {
            themes = Theme.builtins
            print(Color.green.toHex())
        }
    }
}

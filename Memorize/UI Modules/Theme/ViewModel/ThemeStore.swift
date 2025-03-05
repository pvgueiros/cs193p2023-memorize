//
//  ThemeStore.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import Foundation
import SwiftUI

class ThemeStore: ObservableObject {
    
    // MARK: - General Properties
    
    private let userDefaultsKey = "ThemeStore"
    
    var themes: [Theme] {
        get {
            UserDefaults.standard.themes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send() // alternative to @Published, since we are using computed property
            }
        }
    }
    
    // MARK: - Initialization
    
    init() {
        if themes.isEmpty {
            themes = Theme.builtins
        }
    }
    
    // MARK: - Data Formatting
    
    func colorFor(_ theme: Theme) -> Color {
        Color(rgba: theme.colorRGBA)
    }
    
    func titleFor(_ theme: Theme) -> String {
        theme.title
    }
    
    func subtitleFor(_ theme: Theme) -> String {
        let numberOfPairs = theme.numberOfPairs
        let numberOfPairsTitle = (numberOfPairs == theme.emojis.count) ? "All" : "\(numberOfPairs)"
        return numberOfPairsTitle + " pairs from \(theme.emojis)"
    }
    
    // MARK: - Logic & Editing
    
    func themeAtIndex(_ index: Int) -> Theme {
        themes[index]
    }
    
    func indexOf(_ theme: Theme) -> Int? {
        themes.firstIndex { $0.id == theme.id }
    }
    
    func addTheme() -> Theme {
        let newTheme = Theme.defaultNewTheme
        themes.append(newTheme)
        return newTheme
    }
    
    func setColor(_ color: Color, for theme: Theme) {
        if let index = indexOf(theme) {
            themes[index].colorRGBA = color.rgba
        }
    }
    
    // MARK: - Emoji Set Management
    
    func emojiSetRange(for theme: Theme) -> ClosedRange<Int> {
        Theme.minPairsOfCards...theme.emojis.count
    }
    
    func canRemoveEmoji(from theme: Theme) -> Bool {
        theme.emojis.uniqued.count > Theme.minPairsOfCards
    }
}

extension UserDefaults {
    
    // MARK: - Persistance
    
    func themes(forKey key: String) -> [Theme] {
        if let jsonData = data(forKey: key),
            let decodedObject = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            return decodedObject
        } else {
            return []
        }
    }
    
    func set(_ themes: [Theme], forKey key: String) {
        let jsonData = try? JSONEncoder().encode(themes)
        set(jsonData, forKey: key)
    }
}

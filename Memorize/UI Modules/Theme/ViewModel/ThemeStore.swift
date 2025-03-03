//
//  ThemeStore.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

// TODO: - check if makes sense that themes are accessed directly freely
// TODO: - add access control
// TODO: - add section marks

import Foundation
import SwiftUI

class ThemeStore: ObservableObject {
    
    let userDefaultsKey = "ThemeStore"
    
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
    
    init() {
        if themes.isEmpty {
            themes = Theme.builtins
        }
    }
    
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
    
    func indexOf(_ theme: Theme) -> Int? {
        themes.firstIndex { $0.id == theme.id }
    }
    
    // MARK: - Modifying List
    
    func addTheme() -> Theme {
        let newTheme = Theme.defaultNewTheme
        themes.append(newTheme)
        return newTheme
    }
}

extension UserDefaults {
    
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

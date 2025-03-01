//
//  ThemeStore.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import Foundation
import SwiftUI

class ThemeStore: ObservableObject {
    
    let userDefaultsKey = "ThemeStore"
    
    var themePresenters: [ThemePresenter] {
        get {
            UserDefaults.standard.themePresenters(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send() // alternative to @Published, since we are using computed property
            }
        }
    }
    
    init() {
        if themePresenters.isEmpty {
            let themes = Theme.builtins
            for theme in themes {
                themePresenters.append(ThemePresenter(theme: theme))
            }
        }
    }
    
    func indexOfThemePresenter(withId id: Theme.ID) -> Int? {
        themePresenters.firstIndex { $0.id == id }
    }
}

extension UserDefaults {
    
    func themePresenters(forKey key: String) -> [ThemePresenter] {
        if let jsonData = data(forKey: key),
            let decodedObject = try? JSONDecoder().decode([ThemePresenter].self, from: jsonData) {
            return decodedObject
        } else {
            return []
        }
    }
    
    func set(_ themePresenters: [ThemePresenter], forKey key: String) {
        let jsonData = try? JSONEncoder().encode(themePresenters)
        set(jsonData, forKey: key)
    }
}

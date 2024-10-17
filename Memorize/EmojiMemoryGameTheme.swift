//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 16/10/24.
//

import SwiftUI

enum EmojiMemoryGameTheme {
    case nature
    case office
    case fashion
    
    var emojis: [String] {
        switch self {
        case .nature:
            ["🌸", "☀️", "🌳", "💫", "🌲", "🍀", "🌊", "☔️", "🐳", "🐸"]
        case .office:
            ["🖊️", "📌", "📒", "📊", "✂️", "📐", "✏️", "📤", "📎", "💼"]
        case .fashion:
            ["👑", "🧣", "👚", "🩳", "🧦", "🧢", "👗", "👖", "🩱", "👔"]
        }
    }
    
    var buttonImageName: String {
        switch self {
        case .nature: "leaf"
        case .office: "briefcase"
        case .fashion: "tshirt"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .nature: "Nature"
        case .office: "Office"
        case .fashion: "Fashion"
        }
    }
    
    var color: Color {
        switch self {
        case .nature: .green
        case .office: .black
        case .fashion: .purple
        }
    }
}

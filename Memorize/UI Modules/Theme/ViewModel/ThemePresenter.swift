//
//  ThemePresenter.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 26/02/25.
//

//import Foundation
//import SwiftUI
//
//class ThemePresenter: Identifiable, Codable, ObservableObject {
//
//    var theme: Theme
//    var id: Theme.ID { theme.id }
//    
//    init(theme: Theme) {
//        self.theme = theme
//    }
//    
//    var color: Color {
//        Color(rgba: theme.colorRGBA)
//    }
//    
//    var title: String {
//        theme.title
//    }
//    
//    var subtitle: String {
//        let numberOfPairs = theme.numberOfPairs
//        let numberOfPairsTitle = (numberOfPairs == theme.emojis.count) ? "All" : "\(numberOfPairs)"
//        return numberOfPairsTitle + " pairs from \(theme.emojis)"
//    }
//}
//
//extension ThemePresenter: Equatable {
//    static func == (lhs: ThemePresenter, rhs: ThemePresenter) -> Bool {
//        lhs.id == rhs.id
//    }
//}

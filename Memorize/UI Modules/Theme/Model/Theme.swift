//
//  Theme.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import Foundation

struct Theme: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    
    var title: String
    var emojis: String
    var numberOfPairs: Int
    var colorRGBA: RGBA
    
    var removedEmojis: String
    var hasRemovedContent: Bool {
        !removedEmojis.isEmpty
    }
    
    init(title: String, emojis: String, colorRGBA: RGBA) {
        self.title = title
        self.emojis = emojis
        self.removedEmojis = ""
        self.numberOfPairs = Int.random(in: Self.minPairsOfCards...emojis.count)
        self.colorRGBA = colorRGBA
    }
    
    static let minPairsOfCards: Int = 4
    
    static var defaultNewTheme: Theme {
        Theme(
            title: "Hello, World!",
            emojis: "🗺️🌎🌍🌏",
            colorRGBA: RGBA(red: 0/255, green: 200/255, blue: 100/255, alpha: 1)
        )
    }
    
    static var builtins: [Theme] = [
        Theme(title: "Nature",
              emojis: "🌱🌴🌷🍁🍄🦋🌻🐝🐘🦚🪺🪻🪼🏝️🐻‍❄️❄️🌹🦕🦖",
              colorRGBA: RGBA(red: 52/255, green: 199/255, blue: 89/255, alpha: 1)),
        Theme(title: "Office",
              emojis: "🖊️📌📒📊✂️📐✏️📤📎💼📁📃📅📍🗃️🖇️🗂️",
              colorRGBA: RGBA(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)),
        Theme(title: "Fashion",
              emojis: "👑🧣👚🩳🧦🧢👗👖🩱👔🧥🩲👕👙👒",
              colorRGBA: RGBA(red: 175/255, green: 82/255, blue: 222/255, alpha: 1)),
        Theme(title: "Party",
              emojis: "🎉🎈🧁🥳🍾🎁🎂🪩👏🏼🍻🍹🍷",
              colorRGBA: RGBA(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)),
        Theme(title: "Sports",
              emojis: "🏌🏽‍♀️🤾🏻🤾🏽🚴🏻‍♀️⛹🏻‍♀️🏄🏽‍♀️🏋🏻‍♀️🏊🏼‍♀️🥅🏈⚽️🥊🏀🏂⛸️🥍🏹",
              colorRGBA: RGBA(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)),
        Theme(title: "Transportation",
              emojis: "🚙🚜🚲🚠✈️🚂🚁🚤🚢🚀⛽️🛻🛵🚏💺🏍️🛰️",
              colorRGBA: RGBA(red: 0/255, green: 122/255, blue: 255/255, alpha: 1))
    ]
}

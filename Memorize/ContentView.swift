//
//  ContentView.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 07/10/24.
//

import SwiftUI

enum Theme {
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

///
/// ": View" means "behaves like a view" - not it's superclass! Means it conforms to the protocol View
/// Functional programming is about behavior
///
struct ContentView: View {
    let themes: [Theme] = [.nature, .office, .fashion]
    @State var theme: Theme = .nature
    
    var body: some View {
        ScrollView {
            Text("Memorize!")
                .font(.system(size: 32))
            cards
        }
        .foregroundStyle(theme.color)
        .padding()
        themeButtonArea
    }
    
    var cards: some View {
        let numberOfPairs = Int.random(in: 4...theme.emojis.count)
        var emojisComplete = Array(theme.emojis[0..<numberOfPairs])
        emojisComplete = (emojisComplete + emojisComplete).shuffled()
        
        let columns = [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: emojisComplete.count), maximum: widthThatBestFits(cardCount: emojisComplete.count)))]
        
        return LazyVGrid(columns: columns) {
            ForEach(emojisComplete.indices, id: \.self) { index in
                CardView(content: emojisComplete[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
    
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        UIScreen.main.bounds.width / (ceil(sqrt(CGFloat(cardCount))) + 1)
    }
    
    var themeButtonArea: some View {
        HStack (alignment: .bottom) {
            ForEach(themes.indices, id: \.self) { index in
                themeButton(for: themes[index])
            }
            .padding()
        }
    }
    
    func themeButton(for theme: Theme) -> some View {
        Button {
            self.theme = theme
        } label: {
            VStack {
                Image(systemName: theme.buttonImageName).imageScale(.large)
                Text(theme.buttonTitle).font(.caption)
            }
        }
    }
}

struct CardView: View {
    @State var isFaceUp: Bool = false
    var content: String
    
    var body: some View {
        ZStack {
            let baseRectangle = RoundedRectangle(cornerRadius: 10)
            
            baseRectangle.fill()
                .opacity(isFaceUp ? 0 : 1)
            Group {
                baseRectangle.fill(.white)
                baseRectangle.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

//#Preview {
//    ContentView()
//}

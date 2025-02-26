//
//  Extensions.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 25/02/25.
//

import SwiftUI

extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    init(fromHex hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        guard hexSanitized.count == 6, let hexNumber = UInt32(hexSanitized, radix: 16) else {
            self = Color.white
            return
        }
        
        let red = Double((hexNumber >> 16) & 0xFF) / 255.0
        let green = Double((hexNumber >> 8) & 0xFF) / 255.0
        let blue = Double(hexNumber & 0xFF) / 255.0
        
        self = Color(red: red, green: green, blue: blue)
    }
}

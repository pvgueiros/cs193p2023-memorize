//
//  SimpleAlert.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 03/03/25.
//

import SwiftUI

struct SimpleAlert: ViewModifier {
    var titleKey: LocalizedStringKey
    @Binding var isPresented: Bool
    var message: String?
    
    func body(content: Content) -> some View {
        content
            .alert(
                titleKey,
                isPresented: $isPresented,
                actions: {}, // no custom action
                message: {
                    Text(message ?? "")
                }
            )
    }
}

extension View {
    func simpleAlert(_ titleKey: LocalizedStringKey, isPresented: Binding<Bool>, message: String? = nil) -> some View {
        
        modifier(SimpleAlert(titleKey: titleKey, isPresented: isPresented, message: message))
    }
}

#Preview {
    Text("👑")
        .cardify(isFaceUp: true)
        .padding()
}

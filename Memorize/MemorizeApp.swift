//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 07/10/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore()
    
    var body: some Scene {
        WindowGroup {
            ThemeListView()
                .environmentObject(themeStore)
        }
    }
}

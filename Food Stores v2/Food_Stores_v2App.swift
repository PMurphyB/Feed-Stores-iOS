//
//  Food_Stores_v2App.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//

import SwiftUI
import SwiftData

@main
struct Food_Stores_v2App: App {
    
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
    }
}

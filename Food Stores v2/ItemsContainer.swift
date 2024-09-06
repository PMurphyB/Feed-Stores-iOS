//
//  ItemsContainer.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 6/3/24.
//

import Foundation
import SwiftData

actor ItemsContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([Item.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            Category.defaults.forEach { container.mainContext.insert($0) }
            shouldCreateDefaults = false
        }
        return container
    }
}

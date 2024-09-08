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
            
            let categories = CategoriesJSONDecoder.decode(from: "CategoryDefaults")
            
            if categories.isEmpty == false {
                categories.forEach { item in
                    let category = Category(title: item.title)
                    container.mainContext.insert(category)
                }
            }
            
            shouldCreateDefaults = false
        }
        return container
    }
}

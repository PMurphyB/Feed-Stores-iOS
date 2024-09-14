//
//  FoodItem.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id: String
    var name: String
    var carbs: String
    var numOf: String
    
    @Attribute(.externalStorage)
    var image: Data?
    
    @Relationship(deleteRule: .nullify, inverse: \Category.items)
    var category: Category?
    
    init(name: String = "", carbs: String = "", numOf: String = "") {
        self.id = UUID().uuidString
        self.name = name
        self.carbs = carbs
        self.numOf = numOf
    }
}

extension Item {
    static var dummy: Item {
        .init(name: "Item 1", carbs: "80", numOf: "15")
    }
}


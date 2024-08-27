//
//  FoodItem.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//

import Foundation
import SwiftData

@Model
class FoodItem: Identifiable {
    var id: String
    var name: String
    var carbs: String
    var numOf: String
    
    init(name: String = "", carbs: String = "", numOf: String = "") {
        self.id = UUID().uuidString
        self.name = name
        self.carbs = carbs
        self.numOf = numOf
    }
}


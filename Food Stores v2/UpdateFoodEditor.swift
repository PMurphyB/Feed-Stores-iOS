//
//  UpdateFoodEditor.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/14/23.
//

import SwiftUI
import SwiftData

struct UpdateFoodEditor: View {
    @Environment(\.dismiss) var dismiss
    
    @Bindable var item: FoodItem
    
    var body: some View {
        List {
            TextField("Name", text: $item.name)
            TextField("How many?", text: $item.numOf)
                .keyboardType(.numberPad)
            TextField("How many carbs?", text: $item.carbs)
                .keyboardType(.numberPad)
            Button("Update") {
                dismiss()
            }
        }
        .navigationTitle("Update Food Item")
    }
}


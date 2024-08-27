//
//  FoodEditor.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//

import SwiftUI
import SwiftData

struct FoodEditor: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var item = FoodItem()
    
    var body: some View {
        List {
            TextField("Name", text: $item.name)
            TextField("How many?", text: $item.numOf)
                .keyboardType(.numberPad)
            TextField("How many carbs?", text: $item.carbs)
                .keyboardType(.numberPad)
            Button("Create") {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
        .navigationTitle("Create Food Item")
    }
}

#Preview {
    FoodEditor()
        .modelContainer(for: FoodItem.self)
}


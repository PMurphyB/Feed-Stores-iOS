//
//  UpdateFoodEditor.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/14/23.
//

import SwiftUI
import SwiftData

class OriginalFood {
    var name: String
    var carbs: String
    var numOf: String
    
    init(item: Item) {
        self.name = item.name
        self.carbs = item.carbs
        self.numOf = item.numOf
    }
}

struct UpdateFoodView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State var selectedCategory: Category?
    
    @Bindable var item: Item
    
    var body: some View {
        List {
            
            Section("Feed Title") {
                TextField("Name", text: $item.name)
            }
            
            Section("Amount of Feed") {
                TextField("How many?", text: $item.numOf)
                    .keyboardType(.numberPad)
            }
            
            Section("Amount of Carbs") {
                TextField("How many carbs?", text: $item.carbs)
                    .keyboardType(.numberPad)
            }
            
            Section("Select A Category") {
                
                if categories.isEmpty {
                    
                    ContentUnavailableView("No Categories",
                                           systemImage: "archivebox")
                    
                } else {
                    Picker("", selection: $selectedCategory) {
                        
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        
                        Text("None")
                            .tag(nil as Category?)
                        
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                
                
            }
            
            Section {
                Button("Update") {
                    item.category = selectedCategory
                    dismiss()
                }
            }
        }
        .navigationTitle("Update Feed")
        .onAppear(perform: {
            selectedCategory = item.category
        })
    }
}

#Preview {
    UpdateFoodView(item: Item.dummy)
        .modelContainer(for: Item.self)
}

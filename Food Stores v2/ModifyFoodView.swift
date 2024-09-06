//
//  ModifyFoodView.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 1/4/24.
//

import SwiftUI
import SwiftData

struct CreateFoodView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Query private var categories: [Category]
    
    @State var item = Item()
    @State var selectedCategory: Category?
    
    @FocusState private var isInputActive: Bool
    
    var body: some View {
        List {
            
            Section("Feed Title") {
                TextField("Name", text: $item.name)
                    .focused($isInputActive)
            }
            
            Section("Amount of Feed") {
                TextField("How many?", text: $item.numOf)
                    .keyboardType(.numberPad)
                    .focused($isInputActive)
            }
            
            Section("Amount of Carbs") {
                TextField("How many carbs?", text: $item.carbs)
                    .keyboardType(.numberPad)
                    .focused($isInputActive)
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
                Button("Create") {
                    save()
                    dismiss()
                }
            }
            
        }
        .navigationTitle("Create Feed")
        .toolbar {
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            SwiftUI.ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    save()
                    dismiss()
                }
                .disabled(item.name.isEmpty)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isInputActive = false
                }
            }
        }
    }
    
}

private extension CreateFoodView {
    
    func save() {
        modelContext.insert(item)
        item.category = selectedCategory
        selectedCategory?.items?.append(item)
    }
}

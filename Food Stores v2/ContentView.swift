//
//  ContentView.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @Environment(\.modelContext) private var context
    
    @State private var showCreate = false
    @State private var foodItemUpdate: FoodItem?
    @Query(sort: \FoodItem.name) private var items: [FoodItem]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .bold()
                            Text(item.carbs + " Carbs")
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        Button(action: {
                            subtractFood(item)
                        }, label: {
                            Image(systemName: "minus")
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        
                        Text(String(item.numOf))
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            addFood(item)
                        }, label: {
                            Image(systemName: "plus")
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        
                        
                    }
                    .swipeActions {
                    Button(role: .destructive) {
                        withAnimation {
                            context.delete(item)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .symbolVariant(.fill)
                    }
                        
                        Button {
                            foodItemUpdate = item
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                }
                }
            }
            .navigationTitle("My Feed")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showCreate.toggle()
                        }, label: {
                            Label("Add Food", systemImage: "plus")
                        })
                    }
                }
                .sheet(isPresented: $showCreate,
                       content: {
                    NavigationStack {
                        FoodEditor()
                    }
                    .presentationDetents([.medium])
                })
                .sheet(item: $foodItemUpdate) {
                    foodItemUpdate = nil
                } content: { item in
                    UpdateFoodEditor(item: item)
                }

        }
    }
    
    func subtractFood(_ item: FoodItem) {
        var x: Int = Int(item.numOf)!
        x -= 1
        if x <= 0 {
            x = 0
        }
        item.numOf = String(x)
    }
    
    func addFood(_ item: FoodItem) {
        var x: Int = Int(item.numOf)!
        x += 1
        item.numOf = String(x)
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: FoodItem.self)
}

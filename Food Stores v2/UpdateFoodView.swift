//
//  UpdateFoodEditor.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/14/23.
//

import SwiftUI
import SwiftData
import PhotosUI

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
    @State var selectedPhoto: PhotosPickerItem?
    
    @Bindable var item: Item
    
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
                
                if let imageData = item.image,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label("Add Image", systemImage: "photo")
                }
                
                if item.image != nil {
                    
                    Button(role: .destructive) {
                        withAnimation {
                            selectedPhoto = nil
                            item.image = nil
                        }
                    } label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundStyle(.red)
                    }
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    isInputActive = false
                }
            }
        }
        .onAppear(perform: {
            selectedCategory = item.category
        })
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
            }
        }
    }
}

#Preview {
    UpdateFoodView(item: Item.dummy)
        .modelContainer(for: Item.self)
}

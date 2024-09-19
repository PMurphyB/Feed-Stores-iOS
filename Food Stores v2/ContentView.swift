//
//  ContentView.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//  v1.6.1

import SwiftUI
import SwiftData
import SwiftUIImageViewer

enum sortOption: String, CaseIterable {
    case title
    case carbs
    case category
}

extension sortOption {
    
    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .carbs:
            "takeoutbag.and.cup.and.straw.fill"
        case .category:
            "folder"
        }
    }
}

struct ContentView: View {
    
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items:[Item]
    
    @State private var searchQuery = ""
    @State private var showCreateCategory = false
    @State private var showCreateFood = false
    @State private var foodEdit: Item?
    @State private var isImageViewerPresented = false
    
    @State private var selectedSortOption = sortOption.allCases.first!
    
    var filteredItems: [Item] {
        if searchQuery.isEmpty {
            return items.sort(on: selectedSortOption)
        }
        
        let filteredItems = items.compactMap { item in
            let titleContainsQuery = item.name.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            
            let categoryTitleContainsQuery = item.category?.title.range(of: searchQuery,
                                                                  options: .caseInsensitive) != nil
            
            return (titleContainsQuery || categoryTitleContainsQuery) ? item : nil
        }
        
        return filteredItems.sort(on: selectedSortOption)
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            if items.isEmpty {
                
                ContentUnavailableView("No Feed",
                                       systemImage: "archivebox")
                .sheet(item: $foodEdit,
                       onDismiss: {
                    foodEdit = nil
                },
                       content: {editItem in
                    NavigationStack {
                        UpdateFoodView(item: editItem)
                            .interactiveDismissDisabled()
                    }
                })
                .sheet(isPresented: $showCreateCategory,
                       content: {
                    NavigationStack {
                        CreateCategoryView()
                    }
                })
                .sheet(isPresented: $showCreateFood,
                       content: {
                    NavigationStack {
                        CreateFoodView()
                    }
                })
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            showCreateCategory.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                    
                        Menu {
                            Picker("", selection: $selectedSortOption) {
                                ForEach(sortOption.allCases,
                                        id: \.rawValue) { option in
                                    Label(option.rawValue.capitalized,
                                          systemImage: option.systemImage)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()

                        } label: {
                            Image(systemName: "ellipsis")
                                .symbolVariant(.circle)
                        }

                    }
                }
                .safeAreaInset(edge: .bottom,
                               alignment: .leading) {
                    Button(action: {
                        showCreateFood.toggle()
                    }, label: {
                        Label("New Feed", systemImage: "plus")
                            .bold()
                            .font(.title2)
                            .padding(8)
                            .background(.gray.opacity(0.1),
                                        in: Capsule())
                            .padding(.leading)
                            .symbolVariant(.circle.fill)
                    })
                }
                
            } else {
                List {
                    
                    ForEach(filteredItems) { item in
                        
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    Text(item.name)
                                        .font(.largeTitle)
                                        .bold()
                                    
                                    Text(item.carbs + " Carbs")
                                        .font(.callout)
                                    
                                    if let category = item.category {
                                        Text(category.title)
                                            .foregroundStyle(Color.blue)
                                            .bold()
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color.blue.opacity(0.1),
                                                        in: RoundedRectangle(cornerRadius: 8,
                                                                           style: .continuous))
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        subtractFood(item)
                                    }
                                } label: {
                                    Image(systemName: "minus")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                
                                Text(String(item.numOf))
                                    .font(.headline)
                                
                                Button {
                                    withAnimation {
                                        addFood(item)
                                    }
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            if let selectedPhotoData = item.image,
                               let uiImage = UIImage(data: selectedPhotoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 10,
                                                                style: .continuous))
                                    .contentShape(Rectangle())
                                    .ZIndex(-1)
                                    .onTapGesture {
                                        isImageViewerPresented = true
                                    }
                                    .fullScreenCover(isPresented: $isImageViewerPresented) {
                                        SwiftUIImageViewer(image: Image(uiImage: uiImage))
                                            .overlay(alignment: .topTrailing) {
                                                Button {
                                                    isImageViewerPresented = false
                                                } label: {
                                                    Image(systemName: "xmark")
                                                        .font(.headline)
                                                }
                                                .buttonStyle(.bordered)
                                                .clipShape(Circle())
                                                .tint(.blue)
                                                .padding()
                                            }
                                    }
                            }
                        }
                        
                        
                        .swipeActions {
                            
                            Button(role: .destructive) {
                                
                                withAnimation {
                                    modelContext.delete(item)
                                }
                                
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            
                            Button {
                                foodEdit = item
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                        
                    }
                }
                .navigationTitle("My Feed")
                .animation(.easeIn, value: filteredItems)
                .searchable(text: $searchQuery,
                            prompt: "Search for a Feed Item or a Category")
                .overlay {
                    if filteredItems.isEmpty {
                        ContentUnavailableView.search
                    }
                }
                .sheet(item: $foodEdit,
                       onDismiss: {
                    foodEdit = nil
                },
                       content: {editItem in
                    NavigationStack {
                        UpdateFoodView(item: editItem)
                            .interactiveDismissDisabled()
                    }
                })
                .sheet(isPresented: $showCreateCategory,
                       content: {
                    NavigationStack {
                        CreateCategoryView()
                    }
                })
                .sheet(isPresented: $showCreateFood,
                       content: {
                    NavigationStack {
                        CreateFoodView()
                    }
                })
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button {
                            showCreateCategory.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                    
                        Menu {
                            Picker("", selection: $selectedSortOption) {
                                ForEach(sortOption.allCases,
                                        id: \.rawValue) { option in
                                    Label(option.rawValue.capitalized,
                                          systemImage: option.systemImage)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()

                        } label: {
                            Image(systemName: "ellipsis")
                                .symbolVariant(.circle)
                        }

                    }
                }
                .safeAreaInset(edge: .bottom,
                               alignment: .leading) {
                    Button(action: {
                        showCreateFood.toggle()
                    }, label: {
                        Label("New Feed", systemImage: "plus")
                            .bold()
                            .font(.title2)
                            .padding(8)
                            .background(.gray.opacity(0.1),
                                        in: Capsule())
                            .padding(.leading)
                            .symbolVariant(.circle.fill)
                    })
                }
            }
            
            

        }
    }
    
    func subtractFood(_ item: Item) {
        var x: Int = Int(item.numOf)!
        x -= 1
        if x <= 0 {
            x = 0
        }
        item.numOf = String(x)
    }
    
    func addFood(_ item: Item) {
        var x: Int = Int(item.numOf)!
        x += 1
        item.numOf = String(x)
    }
    
    private func delete(item: Item) {
        withAnimation {
            modelContext.delete(item)
        }
    }
    
}

private extension [Item] {
    
    func sort(on option: sortOption) -> [Item] {
        switch option {
        case .title:
            self.sorted(by: { $0.name < $1.name })
        case .carbs:
            self.sorted(by: { $0.carbs < $1.carbs })
        case .category:
            self.sorted(by: {
                guard let firstItemTitle = $0.category?.title,
                      let secondItemTitle = $1.category?.title else { return false }
                return firstItemTitle < secondItemTitle
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

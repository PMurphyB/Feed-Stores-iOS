//
//  CategoriesJSONDecoder.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 6/4/24.
//

import Foundation

struct CategoryResponse: Decodable {
    let title: String
}

struct CategoriesJSONDecoder {
    
    static func decode(from fileName: String) -> [CategoryResponse] {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let categories = try? JSONDecoder().decode([CategoryResponse].self, from: data) else {
            return []
        }
        
        return categories
    }
}

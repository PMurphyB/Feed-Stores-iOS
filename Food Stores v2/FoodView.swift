//
//  FoodEditor.swift
//  Food Stores v2
//
//  Created by Payton Murphy on 12/13/23.
//

import SwiftUI

struct FoodView: View {
    
    let item: Item
    
    var body: some View {
        VStack (alignment: .leading){
            Text(item.name)
                .font(.largeTitle)
                .bold()
            
            Text(item.numOf)
                .font(.callout)
        }
    }
}

#Preview {
    FoodView(item: .dummy)
}

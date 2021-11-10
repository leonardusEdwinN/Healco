//
//  KonsumsiDetailNutrient.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 20/08/21.
//

import Foundation
import SwiftUI

struct KonsumsiDetailNutrientItem: View {
    var title : String
    var description : String
    
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            Text("\(title) ").font(.custom("SF-Compact-Display-Regular", size: 14))
            Text("\(description)").font(.custom("SF-Compact-Display-Semibold", size: 17))
        }.padding(.horizontal, 20)
        
    }
}

struct KonsumsiDetailNutrientItem_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailNutrientItem(title: "Karbohidrat", description: "50")
        KonsumsiDetailNutrientItem(title: "Protein", description: "20")
    }
}

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
        HStack{
            Text("\(title) ")
            Spacer()
            Text("\(description) gr")
        }.padding(.horizontal, 10)
        
    }
}

struct KonsumsiDetailNutrientItem_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailNutrientItem(title: "Karbohidrat", description: "50")
        KonsumsiDetailNutrientItem(title: "Protein", description: "20")
    }
}

//
//  KonsumsiDetailNutrient.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 20/08/21.
//

import Foundation
import SwiftUI

struct KonsumsiDetailNutrient: View {
    var kalori : String
    var karbohidrat : String
    var protein : String
    var lemak : String
    
    
    var body: some View {
            VStack{
                Text("\(kalori) kal").font(.title2).padding(.vertical, 10)
                KonsumsiDetailNutrientItem(title: "Karbohidrat", description: "\(karbohidrat)")
                KonsumsiDetailNutrientItem(title: "Protein", description: "\(protein)")
                KonsumsiDetailNutrientItem(title: "Lemak", description: "\(lemak)").padding(.bottom, 10)
               
            }.background(Color("DarkGray")).cornerRadius(20)
        
        
    }
}

struct KonsumsiDetailNutrient_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailNutrient(kalori: "300", karbohidrat: "50", protein: "30", lemak: "10")
    }
}

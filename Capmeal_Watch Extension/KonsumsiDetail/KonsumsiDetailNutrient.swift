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
        VStack(alignment: .leading, spacing: 10){
            KonsumsiDetailNutrientItem(title: "Total Kalori", description: "\(kalori) Kal").padding(.top, 10)
                KonsumsiDetailNutrientItem(title: "Karbohidrat", description: "\(karbohidrat) gr")
                KonsumsiDetailNutrientItem(title: "Protein", description: "\(protein) gr")
                KonsumsiDetailNutrientItem(title: "Lemak", description: "\(lemak) gr").padding(.bottom, 10)
               
        }.frame(maxWidth: .infinity, alignment: .leading).background(Color("DarkGray")).cornerRadius(20)
        
        
    }
}

struct KonsumsiDetailNutrient_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailNutrient(kalori: "300", karbohidrat: "50", protein: "30", lemak: "10")
    }
}

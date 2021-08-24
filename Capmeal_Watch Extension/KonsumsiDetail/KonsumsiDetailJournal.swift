//
//  KonsumsiDetailJournalItem.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 20/08/21.
//

import Foundation
import SwiftUI

struct KonsumsiDetailJournal: View {
    var titleJournal : String
    var porsi : String
    var aktivitas : String
    var perasaan : String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
                KonsumsiDetailNutrientItem(title: "Waktu Sarapan", description: "\(titleJournal)").padding(.top, 10)
                KonsumsiDetailNutrientItem(title: "Porsi", description: "\(porsi)")
                KonsumsiDetailNutrientItem(title: "Aktivitas", description: "\(aktivitas)")
            KonsumsiDetailNutrientItem(title: "Perasaan", description: "\(perasaan)").padding(.bottom, 10)
            }.frame(maxWidth: .infinity, alignment: .leading).background(Color("DarkGray")).cornerRadius(20)
        
        
    }
}

struct KonsumsiDetailJournal_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailJournal(titleJournal: "Sarapan", porsi: "100", aktivitas: "Gak Ada", perasaan: "Biasa aja 😊")
    }
}

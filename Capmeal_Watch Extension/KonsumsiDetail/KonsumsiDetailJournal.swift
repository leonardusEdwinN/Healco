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
            VStack{
                Text("\(titleJournal)").font(.title3).padding(.vertical, 10)
                
                KonsumsiDetailJournalItem(title: "Porsi", detail: "\(porsi)")
                
                KonsumsiDetailJournalItem(title: "Aktivitas", detail: "\(aktivitas)")
                
                KonsumsiDetailJournalItem(title: "Perasaan", detail: "\(perasaan)").padding(.bottom, 10)
            }.background(Color("DarkGray")).cornerRadius(20)
        
        
    }
}

struct KonsumsiDetailJournal_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailJournal(titleJournal: "Sarapan", porsi: "100", aktivitas: "Gak Ada", perasaan: "Biasa aja 😊")
    }
}

//
//  KonsumsiDetailJournalItem.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 20/08/21.
//

import Foundation
import SwiftUI

struct KonsumsiDetailJournalItem: View {
    var title : String
    var detail : String
    
    var body: some View {
        HStack(alignment: .center, spacing: 5){
            Text("\(title)").frame(width: 75, height: 25, alignment: .leading)
            Text("\(detail)")
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
        
        
    }
}

struct KonsumsiDetailJournalItem_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetailJournalItem(title: "Porsi", detail: "100 gr")
    }
}

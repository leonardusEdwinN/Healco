//
//  KonsumsiDetail.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 20/08/21.
//

import Foundation
import SwiftUI

struct KonsumsiDetail: View {

    var dataKonsumsi: FoodDummy
    
    var body: some View {
        ScrollView{
            VStack{
                ListKonsumsiItem(image: "\(dataKonsumsi.image)", title: "\(dataKonsumsi.title)")
                KonsumsiDetailNutrient(kalori: "300", karbohidrat: "50", protein: "30", lemak: "10")
                KonsumsiDetailJournal(titleJournal: "Sarapan", porsi: "100 gr", aktivitas: "Gak Ada", perasaan: "Happy 😄")
            }.navigationTitle("Detail")
        }
        
        
    }
}

struct KonsumsiDetail_Previews: PreviewProvider {
    static var previews: some View {
        KonsumsiDetail(dataKonsumsi: FoodDummy(id: 1, image: "breakfast", title: "Makanan Pagi"))
    }
}

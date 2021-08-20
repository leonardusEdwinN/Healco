//
//  ListKonsumsi.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 19/08/21.
//

import Foundation
import SwiftUI

struct FoodDummy: Hashable{
    var id: Int
    var image: String
    var title: String
}

struct ListKonsumsi: View {
    var dataKonsumsiDummy: [FoodDummy] = [
        FoodDummy(id: 1, image: "breakfast", title: "Yoghurt with Ice Cream Chocolate"),
        FoodDummy(id: 2, image: "lunch", title: "KFC bucket With 3 Rice"),
        FoodDummy(id: 3, image: "dinner", title: "Richesse chicken fire wing level 5"),
        FoodDummy(id: 4, image: "snack", title: "Indomie goreng"),
        FoodDummy(id: 5, image: "breakfast", title: "Martabak Sultan Keju"),
    ]
    
    var body: some View {
        
        
            List{
                ForEach(dataKonsumsiDummy, id: \.self) {konsumsi in
                    NavigationLink(destination: KonsumsiDetail(dataKonsumsi: konsumsi)) {
                        ListKonsumsiItem(image: konsumsi.image, title: konsumsi.title)
                    }
                }
            }
        
        
//        NavigationLink(
//            destination: KonsumsiDetail(dataKonsumsi: FoodDummy(id: 1, image: dataKonsumsiDummy[1].image, title: dataKonsumsiDummy[1].title))){
//            ListKonsumsiItem(image: dataKonsumsiDummy[1].image, title: dataKonsumsiDummy[1].title)
//        }
        
        
    }
}

struct ListKonsumsi_Previews: PreviewProvider {
    static var previews: some View {
        ListKonsumsi()
    }
}

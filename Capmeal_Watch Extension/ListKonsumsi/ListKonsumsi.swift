//
//  ListKonsumsi.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 19/08/21.
//

import Foundation
import SwiftUI

struct ListKonsumsi: View {
    var body: some View {
        ScrollView{
            VStack{
                ListKonsumsiItem(image: "breakfast", title: "Yoghurt with Ice cream chocolate")
                ListKonsumsiItem(image: "lunch", title: "KFC bucket With 3 rice")
                ListKonsumsiItem(image: "dinner", title: "Richesse chicken fire wing level 5")
                ListKonsumsiItem(image: "snack", title: "Chocolate bar cadburry")
                ListKonsumsiItem(image: "snack", title: "Indomie goreng")
                ListKonsumsiItem(image: "snack", title: "Martabak Sultan Keju")
            }
        }
    }
}

struct ListKonsumsi_Previews: PreviewProvider {
    static var previews: some View {
        ListKonsumsi()
    }
}

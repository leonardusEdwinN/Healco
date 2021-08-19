//
//  ListKonsumsiItem.swift
//  Capmeal_Watch Extension
//
//  Created by Edwin Niwarlangga on 19/08/21.
//



import Foundation
import SwiftUI

struct ListKonsumsiItem: View {
    var image: String = "" //nanti bisa di ganti string
    var title: String = ""
    
    var body: some View {
            VStack{
                Image(image).resizable()
                    .aspectRatio(contentMode: .fit).padding()
                Text(title).padding(10)
            }.background(Color("DarkGray")).cornerRadius(15)
        
        
    }
}

struct ListKonsumsiItem_Previews: PreviewProvider {
    static var previews: some View {
        ListKonsumsiItem()
    }
}

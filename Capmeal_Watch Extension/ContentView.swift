//
//  ContentView.swift
//  Capmeal_Watch Extension
//
//  Created by Ericson Hermanto on 18/08/21.
//

import SwiftUI

extension Color {
    static let Avocado = Color(red: 100 / 255, green: 150 / 255, blue: 73 / 255)
    static let darkPink = Color(red: 208 / 255, green: 45 / 255, blue: 208 / 255)
    static let DarkGray = Color(red: 36 / 255, green: 36 / 255, blue: 36 / 255)
}

struct makroNutrient {
    var namaMakro : String = ""
    var presentasi : Int = 0
}
struct ProgressBar : View {
    @Binding var value : Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.Avocado)
                    .frame(width: geometry.size.width, height: 15)
                    .opacity(0.5)
                    
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.Avocado)
                    .frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: 15, alignment: .leading)
            }
        }
    }
}

struct MakroNutrient : View{
    @Binding var makroNutrient : makroNutrient

    var body: some View{
        
        ZStack(alignment: .center){
            GeometryReader{ geometry in
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: geometry.size.width, height: 40 )
                    .foregroundColor(Color.DarkGray)
            }
            HStack{
                Text("\(makroNutrient.presentasi)%").frame(width: 50, height: 40)
                Text(makroNutrient.namaMakro).frame(width: 100, height: 40, alignment: .leading)
            }

        }
       
       
    }
}

struct ContentView: View {
    @State var currentProgress: Float = 0.2
    @State var makro : [makroNutrient] = [
        makroNutrient(namaMakro: "Karbohidrat", presentasi: 0),
        makroNutrient(namaMakro: "Protein", presentasi: 0),
        makroNutrient(namaMakro: "Lemak", presentasi: 0)

    ]
    

    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text("700").font(.largeTitle)
                    Text("kal/1368 kal")
                }
                ProgressBar(value: $currentProgress).frame(height: 20)
                    .padding()

                MakroNutrient(makroNutrient: $makro[0]).frame(height: 40).padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                MakroNutrient(makroNutrient: $makro[1]).frame(height: 40).frame(height: 40).padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                MakroNutrient(makroNutrient: $makro[2]).frame(height: 40).frame(height: 40).padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))

            }.navigationTitle(Text("Capmeal")).navigationBarHidden(false)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

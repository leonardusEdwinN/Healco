//
//  ContentView.swift
//  Capmeal_Watch Extension
//
//  Created by Ericson Hermanto on 18/08/21.
//

import SwiftUI

extension Color {
    static let Avocado = Color(red: 100 / 255, green: 150 / 255, blue: 73 / 255)
    static let DarkGray = Color(red: 36 / 255, green: 36 / 255, blue: 36 / 255)
}

struct makroNutrient {
    var namaMakro : String = ""
    var presentasi : Int = 0
}

enum currentView{
    case firstView
    case secondView
}

let width = WKInterfaceDevice.current().screenBounds.width
let height = WKInterfaceDevice.current().screenBounds.height
let screenSize = WKInterfaceDevice.current().screenBounds

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
    @State private var currentCal : Int = 700
    @State private var targetCal : Int = 1368
    @State var activeView = currentView.firstView
    @State var viewState = CGSize.zero
    @State var navigationTitle = "Capmeal"

    var body: some View {
        VStack(spacing:0){
            
            Spacer(minLength: 30)
            ZStack{
                //FirstView
                FirstView(activeView: self.activeView, navigationTitle: $navigationTitle,  makro: $makro, currentProgress: $currentProgress, currentCal: $currentCal, targetCal: $targetCal) .animation(.easeInOut)
                
                //secondView
                SecondView(activeView: self.activeView, navigationTitle: $navigationTitle)
                    .offset(x: self.activeView == currentView.secondView ? 0 : width)
                    .offset(x: activeView != .secondView ? viewState.width : 0)
                    .animation(.easeInOut)

                
            }.navigationTitle(Text(navigationTitle)).navigationBarHidden(false)

            
            .gesture(
                (self.activeView == currentView.firstView) ?
                    DragGesture().onChanged { value in
                        
                        self.viewState = value.translation
                        
                    }
                    .onEnded { value in
                        if value.predictedEndTranslation.width < -width / 2  {
                            self.activeView = currentView.secondView
                            self.viewState = .zero
                            navigationTitle = "Konsumsi"
                        }
                        else {
                            self.viewState = .zero

                        }
                        
                    }
                    : DragGesture().onChanged { value in
                        switch self.activeView {
                        case .secondView:
                            guard value.translation.width > 1 else { return }
                            self.viewState = value.translation

                        case .firstView:
                            self.viewState = value.translation

                        }
                        
                    }
                    
                    .onEnded { value in
                        switch self.activeView {
                        case .secondView:
                            navigationTitle = "Capmeal"
                            if value.predictedEndTranslation.width > width / 2 {
                                self.activeView = .firstView
                                self.viewState = .zero
                            }
                            else {
                                self.viewState = .zero
                            }
                        case .firstView:

                            self.viewState = .zero
                            
                        }
                    }

            
            )

            //Page Control
            HStack{
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(activeView == .secondView ? Color.gray:Color.Avocado)
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(activeView == .secondView ? Color.Avocado:Color.gray)
            }

        }.frame(width: width, height: height)
        
    }
}

struct FirstView : View {
    @State var activeView : currentView
    @Binding var navigationTitle : String
    @Binding var makro : [makroNutrient]
    @Binding var currentProgress : Float
    @Binding var currentCal : Int
    @Binding var targetCal : Int
    
    var body : some View {
        
        ScrollView{
            VStack{
                HStack{
                    Text("\(currentCal)").font(.largeTitle)
                    Text("kal/\(targetCal) kal")
                }
                ProgressBar(value: $currentProgress).frame(height: 20)
                    .padding()

                MakroNutrient(makroNutrient: $makro[0]).frame(height: 40).padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                MakroNutrient(makroNutrient: $makro[1]).frame(height: 40).frame(height: 40).padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
                MakroNutrient(makroNutrient: $makro[2]).frame(height: 40).frame(height: 40).padding(.init(top: 0, leading: 8, bottom: 0, trailing: 8))

            }
        }
    }
}


struct SecondView : View {
    @State var activeView : currentView
    @Binding var navigationTitle : String
    var body : some View {
        GeometryReader { bounds in
            VStack {
                Text("SecondView")
                
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

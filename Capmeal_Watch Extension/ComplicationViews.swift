//
//  ComplicationViews.swift
//  Capmeal_Watch Extension
//
//  Created by Fahmi Dzulqarnain on 20/08/21.
//

import SwiftUI
import ClockKit

struct ComplicationViews: View {
    var body: some View {
        Text("Hai, Dunia Yang Sementara!")
    }
}

struct ComplicationViewCircular: View {
  var calorieIntake: CalorieIntake

  var body: some View {
    ZStack {
      ProgressView("\(calorieIntake.intakeCal)", value: (calorieIntake.percentCal), total: 1.0)
        .progressViewStyle(CircularProgressViewStyle(tint: Color.Avocado))
    }
  }
}

struct ComplicationViewCornerCircular: View {
  var calorieIntake: CalorieIntake

  var body: some View {
    ZStack {
        Circle().fill(Color.Avocado)
        Text("\(calorieIntake.intakeCal)")
            .foregroundColor(Color.white)
    }
  }
}

struct ComplicationViewRectangle: View {
  var calorieIntake: CalorieIntake

  var body: some View {
    ZStack {
        Rectangle().fill(Color.Avocado).cornerRadius(10.0)
        Text("\(calorieIntake.intakeCal)")
            .foregroundColor(Color.white)
    }
  }
}

struct CalorieIntake {
    var intakeCal: Int32
    var percentCal: Double
}

struct ComplicationViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular(
                    calorieIntake: CalorieIntake(intakeCal: 300, percentCal: 0.7)
                )
            ).previewContext()
            
            CLKComplicationTemplateGraphicCornerCircularView(
                ComplicationViewCornerCircular(
                    calorieIntake: CalorieIntake(intakeCal: 300, percentCal: 0.7)
                )
            ).previewContext()
            
            CLKComplicationTemplateGraphicRectangularFullView(
                ComplicationViewRectangle(
                    calorieIntake: CalorieIntake(intakeCal: 300, percentCal: 0.3)
                )
            )
            .previewContext()
        }
    }
}

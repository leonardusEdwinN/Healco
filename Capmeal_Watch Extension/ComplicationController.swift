//
//  ComplicationController.swift
//  Capmeal_Watch Extension
//
//  Created by Ericson Hermanto on 18/08/21.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let dataController: CalorieIntake? = CalorieIntake(intakeCal: 365, percentCal: 0.3)
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Capmeal", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(Date())
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let calorie = dataController,
          let template = makeTemplate(for: calorie, complication: complication) {
          let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
          handler(entry)
        } else {
          handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let timeline = dataController

        var entries: [CLKComplicationTimelineEntry] = []
        var current = date
        let endDate = Date().addingTimeInterval(1000)

        while (current.compare(endDate) == .orderedAscending) &&
          (entries.count < limit) {
          if let next = dataController,
            let template = makeTemplate(for: next, complication: complication) {
            let entry = CLKComplicationTimelineEntry(
              date: current,
              complicationTemplate: template)
            entries.append(entry)
          }
          current = current.addingTimeInterval(5.0 * 60.0)
        }

        handler(entries)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}

extension ComplicationController {
  func makeTemplate(for calorieIntake: CalorieIntake, complication: CLKComplication) -> CLKComplicationTemplate? {
    switch complication.family {
    case .graphicCircular:
        return CLKComplicationTemplateGraphicCircularView(
            ComplicationViewCircular(calorieIntake: calorieIntake)
        )
    case .graphicCorner:
        return CLKComplicationTemplateGraphicCornerCircularView(
            ComplicationViewCornerCircular(calorieIntake: calorieIntake)
        )
    case .graphicRectangular:
        return CLKComplicationTemplateGraphicRectangularFullView(
            ComplicationViewRectangle(calorieIntake: calorieIntake)
        )
    default:
      return nil
    }
  }
}

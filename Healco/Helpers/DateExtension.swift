//
//  DateExtension.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 30/07/21.
//

import Foundation
//extension Date {
//
//  static func today() -> Date {
//      return Date()
//  }
//
//  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
//    return get(.next,
//               weekday,
//               considerToday: considerToday)
//  }
//
//  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
//    return get(.previous,
//               weekday,
//               considerToday: considerToday)
//  }
//
//  func get(_ direction: SearchDirection,
//           _ weekDay: Weekday,
//           considerToday consider: Bool = false) -> Date {
//
//    let dayName = weekDay.rawValue
//
//    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
//
//    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
//
//    let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
//
//    let calendar = Calendar(identifier: .gregorian)
//
//    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
//      return self
//    }
//
//    var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
//    nextDateComponent.weekday = searchWeekdayIndex
//
//    let date = calendar.nextDate(after: self,
//                                 matching: nextDateComponent,
//                                 matchingPolicy: .nextTime,
//                                 direction: direction.calendarSearchDirection)
//
//    return date!
//  }
//
//}
//
//// MARK: Helper methods
//extension Date {
//  func getWeekDaysInEnglish() -> [String] {
//    var calendar = Calendar(identifier: .gregorian)
//    calendar.locale = Locale(identifier: "en_US_POSIX")
//    return calendar.weekdaySymbols
//  }
//
//  enum Weekday: String {
//    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
//  }
//
//  enum SearchDirection {
//    case next
//    case previous
//
//    var calendarSearchDirection: Calendar.SearchDirection {
//      switch self {
//      case .next:
//        return .forward
//      case .previous:
//        return .backward
//      }
//    }
//  }
//}

extension Date {

   func isBetween(_ date1: Date, and date2: Date) -> Bool {
      return (min(date1, date2) ... max(date1, date2)).contains(self)
   }

   var startOfWeek: Date? {
    let calendar = Calendar.current
      return calendar.dateInterval(of: .weekOfMonth, for: self)?.start
   }

   var endOfWeek: Date? {
    let calendar = Calendar.current
       return calendar.dateInterval(of: .weekOfMonth, for: self)?.end
   }

   var startOfMonth: Date? {
    let calendar = Calendar.current
       return calendar.dateInterval(of: .month, for: self)?.start
   }

   var endOfMonth: Date? {
    let calendar = Calendar.current
       return calendar.dateInterval(of: .month, for: self)?.end
   }

   var weekNumber: Int? {
    let calendar = Calendar.current
       let currentComponents = calendar.dateComponents([.weekOfYear], from: self)
       return currentComponents.weekOfYear
   }

   var monthNumber: Int? {
    let calendar = Calendar.current
       let currentComponents = calendar.dateComponents([.month], from: self)
       return currentComponents.month
   }
    
    func getFirstDay(WeekNumber weekNumber:Int, CurrentYear currentYear: Int)->String?{
        let Calendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dayComponent = DateComponents()
        dayComponent.weekOfYear = weekNumber
        dayComponent.weekday = 1
        dayComponent.year = currentYear
        var date = Calendar.date(from: dayComponent)
        
        if(weekNumber == 1 && Calendar.components(.month, from: date!).month != 1){
            //print(Calendar.components(.month, from: date!).month)
            dayComponent.year = currentYear - 1
            date = Calendar.date(from: dayComponent)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return String(dateFormatter.string(from: date!))
    }
    
    func hariPertamaDalamMinggu(using calendar: Calendar = .gregorian) -> Date {
           calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
       }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

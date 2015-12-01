//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

extension NSDate {

    private static var longDateRelativeFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateStyle = .LongStyle
            Static.formatter.doesRelativeDateFormatting = true
        }

        return Static.formatter
    }

    var longDateRelativeString: String {
        return NSDate.longDateRelativeFormatter.stringFromDate(self)
    }
}

extension NSDate {
    // Long string

    private static var longDateFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateStyle = .LongStyle
        }

        return Static.formatter
    }

    var longDateString: String {
        return NSDate.longDateFormatter.stringFromDate(self)
    }
}

extension NSDate {
    // Date component string

    private static var dateComponentFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateFormat = "yyyy-MM-dd"
        }

        return Static.formatter
    }

    static func dateWithDateComponent(dateComponent: String) -> NSDate? {
        return dateComponentFormatter.dateFromString(dateComponent)
    }

    var dateComponent: String {
        return NSDate.dateComponentFormatter.stringFromDate(self)
    }
}

extension NSDate {

    private static var monthYearFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateFormat = "MMMM, yyyy"
        }

        return Static.formatter
    }

    static func dateWithMonthYear(monthYear: String) -> NSDate? {
        return monthYearFormatter.dateFromString(monthYear)
    }

    var monthYear: String {
        return NSDate.monthYearFormatter.stringFromDate(self)
    }

}

extension NSDate {
    // Next and previous days, months

    var nextDay: NSDate {
        return dateByAddingTimeInterval(24 * 60 * 60)
    }

    var firstDayOfMonth: NSDate? {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: self)
        return calendar.dateFromComponents(dateComponents)
    }

    var nextMonth: NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 1, toDate: self, options: [])
    }

    var previousDay: NSDate {
        return dateByAddingTimeInterval(-24 * 60 * 60)
    }

    var previousMonth: NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: self, options: [])
    }
}
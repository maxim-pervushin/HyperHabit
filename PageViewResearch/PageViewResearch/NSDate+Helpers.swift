//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import Foundation

extension NSDate {

    func sharedCalendar(){

    }

    func firstDayOfMonth () -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components([.Year, .Month, .Day ], fromDate: self)
        dateComponent.day = 1
        return calendar.dateFromComponents(dateComponent)!
    }

    convenience init(year : Int, month : Int, day : Int) {

        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        self.init(timeInterval:0, sinceDate:calendar.dateFromComponents(dateComponent)!)
    }

    func dateByAddingMonths(months : Int ) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.month = months
        return calendar.dateByAddingComponents(dateComponent, toDate: self, options: NSCalendarOptions.MatchNextTime)!
    }

    func dateByAddingDays(days : Int ) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.day = days
        return calendar.dateByAddingComponents(dateComponent, toDate: self, options: NSCalendarOptions.MatchNextTime)!
    }

    func hour() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Hour, fromDate: self)
        return dateComponent.hour
    }

    func second() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Second, fromDate: self)
        return dateComponent.second
    }

    func minute() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Minute, fromDate: self)
        return dateComponent.minute
    }

    func day() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Day, fromDate: self)
        return dateComponent.day
    }

    func weekday() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Weekday, fromDate: self)
        return dateComponent.weekday
    }

    func month() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Month, fromDate: self)
        return dateComponent.month
    }

    func year() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components(.Year, fromDate: self)
        return dateComponent.year
    }

    func numberOfDaysInMonth() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let days = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self)
        return days.length
    }

    func dateByIgnoringTime() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = calendar.components([.Year, .Month, .Day ], fromDate: self)
        return calendar.dateFromComponents(dateComponent)!
    }

    func monthNameFull() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.stringFromDate(self)
    }

    func isSunday() -> Bool
    {
        return (self.getWeekday() == 1)
    }

    func isMonday() -> Bool
    {
        return (self.getWeekday() == 2)
    }

    func isTuesday() -> Bool
    {
        return (self.getWeekday() == 3)
    }

    func isWednesday() -> Bool
    {
        return (self.getWeekday() == 4)
    }

    func isThursday() -> Bool
    {
        return (self.getWeekday() == 5)
    }

    func isFriday() -> Bool
    {
        return (self.getWeekday() == 6)
    }

    func isSaturday() -> Bool
    {
        return (self.getWeekday() == 7)
    }

    func getWeekday() -> Int {
        let calendar = NSCalendar.currentCalendar()
        return calendar.components( .Weekday, fromDate: self).weekday
    }

    func isToday() -> Bool {
        let cal = NSCalendar.currentCalendar()
        var components = cal.components([.Era, .Year, .Month, .Day], fromDate:NSDate())
        let today = cal.dateFromComponents(components)!

        components = cal.components([.Era, .Year, .Month, .Day], fromDate:self);
        let otherDate = cal.dateFromComponents(components)!
        return (today.isEqualToDate(otherDate))

    }
}

func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}

func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

func <=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending || lhs.compare(rhs) == NSComparisonResult.OrderedSame
}

func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return rhs.compare(lhs) == NSComparisonResult.OrderedAscending
}

func >=(lhs: NSDate, rhs: NSDate) -> Bool {
    return rhs.compare(lhs) == NSComparisonResult.OrderedAscending || rhs.compare(lhs) == NSComparisonResult.OrderedSame
}

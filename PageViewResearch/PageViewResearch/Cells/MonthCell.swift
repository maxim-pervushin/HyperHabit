//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MonthCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    static let defaultIdentifier = "MonthCell"

    static func calculateHeight(month: NSDate, width: CGFloat, calendar: NSCalendar) -> CGFloat {
        let cellSide = width / 7
        let days = daysBeforeInMonth(month, calendar: calendar) + month.numberOfDaysInMonth() + daysAfterInMonth(month, calendar: calendar)
        let rows = days / 7
        let height = CGFloat(rows + 1) * cellSide

//        print("");
//        print("title:\(titleFormatter.stringFromDate(month))");
//        print("width:\(width), cellSide:\(cellSide), days:\(days), rows:\(rows), height:\(height)");
//        print("daysBeforeInMonth(month):\(daysBeforeInMonth(month, calendar: calendar)), daysAfterInMonth(month):\(daysAfterInMonth(month, calendar: calendar)), month.numberOfDaysInMonth():\(month.numberOfDaysInMonth())");

        return height
    }

    static private func daysBeforeInMonth(inMonth: NSDate, calendar: NSCalendar) -> Int {
        let firstDayWeekday = inMonth.firstDayOfMonth().weekday()
        return firstDayWeekday >= calendar.firstWeekday ? firstDayWeekday - calendar.firstWeekday : 7 - firstDayWeekday
    }

    static private func daysAfterInMonth(inMonth: NSDate, calendar: NSCalendar) -> Int {
        let days = inMonth.numberOfDaysInMonth() + daysBeforeInMonth(inMonth, calendar: calendar)
        return days % 7 != 0 ? 7 - days % 7 : 0
    }


    var month: NSDate? {
        didSet {
            collectionView.reloadData()
            titleLabel?.text = monthTitle()
        }
    }

    var startDate: NSDate?
    var endDate: NSDate?

    var calendar = NSCalendar.currentCalendar() {
        didSet {
            collectionView.reloadData()
        }
    }

    private static var titleFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateFormat = "LLLL YYYY"
        }

        return Static.formatter
    }

    private static var dayFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateFormat = "EE"
        }

        return Static.formatter
    }

    private func daysBeforeInMonth(inMonth: NSDate) -> Int {
        let firstDayWeekday = inMonth.firstDayOfMonth().weekday()
        return firstDayWeekday >= calendar.firstWeekday ? firstDayWeekday - calendar.firstWeekday : 7 - firstDayWeekday
    }

    private func daysAfterInMonth(inMonth: NSDate) -> Int {
        let days = inMonth.numberOfDaysInMonth() + daysBeforeInMonth(inMonth)
        return days % 7 != 0 ? 7 - days % 7 : 0
    }

    private func monthTitle() -> String {
        if let month = month {
            return MonthCell.titleFormatter.stringFromDate(month)
        }
        return ""
    }

    private func dayTitle(dayIndex: Int) -> String {
        var index = calendar.firstWeekday + dayIndex - 1
        while index > 6 {
            index -= 7
        }
        let title = MonthCell.dayFormatter.shortWeekdaySymbols[index]
        return title
    }
}

extension MonthCell: UICollectionViewDataSource {

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let _ = month else {
            return 0
        }
        return 3
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let month = month else {
            return 0
        }

        if section == 0 {
            return 1
        } else if section == 1 {
            return 7
        }

        return daysBeforeInMonth(month) + month.numberOfDaysInMonth() + daysAfterInMonth(month)
    }

    private func monthTitleCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextCell.defaultReuseIdentifier, forIndexPath: indexPath) as! TextCell
        cell.text = monthTitle()
        return cell
    }

    private func dayTitleCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TextCell.defaultReuseIdentifier, forIndexPath: indexPath) as! TextCell
        cell.text = dayTitle(indexPath.row)
        return cell
    }

    private func emptyCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EmptyCell.defaultReuseIdentifier, forIndexPath: indexPath)
    }

    private func dayCell(collectionView: UICollectionView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! DayCell
        cell.date = date
        return cell
    }

    private func inactiveDayCell(collectionView: UICollectionView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(InactiveDayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! InactiveDayCell
        cell.date = date
        return cell
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return monthTitleCell(collectionView, indexPath: indexPath)

        } else if indexPath.section == 1 {
            return dayTitleCell(collectionView, indexPath: indexPath)

        } else {
            guard let month = month else {
                return emptyCell(collectionView, indexPath: indexPath)
            }

            let daysBefore = daysBeforeInMonth(month)
            let cellDate = month.firstDayOfMonth().dateByAddingDays(indexPath.row - daysBefore)

            if indexPath.row < daysBefore || indexPath.row >= daysBefore + month.numberOfDaysInMonth() {
                return emptyCell(collectionView, indexPath: indexPath)

            } else if let startDate = startDate where cellDate < startDate {
                return inactiveDayCell(collectionView, indexPath: indexPath, date: cellDate)

            } else if let endDate = endDate where cellDate > endDate {
                return inactiveDayCell(collectionView, indexPath: indexPath, date: cellDate)

            } else {
                return dayCell(collectionView, indexPath: indexPath, date: cellDate)
            }
        }
    }
}

extension MonthCell: UICollectionViewDelegate {
}

extension MonthCell: UICollectionViewDelegateFlowLayout {

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = collectionView.frame.size.width / 7
        if indexPath.section == 0 {
            return CGSizeMake(collectionView.frame.size.width, side / 2)
        } else if indexPath.section == 1 {
            return CGSizeMake(side, side / 2)
        }
        return CGSizeMake(side, side)
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
}
//
// Created by Maxim Pervushin on 15/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MXMonthView: UIView {

    // MARK: MXMonthView @IB

    @IBOutlet weak var collectionView: UICollectionView!

    static private func daysBeforeInMonth(inMonth: NSDate, calendar: NSCalendar) -> Int {
        let firstDayWeekday = inMonth.firstDayOfMonth().weekday()
        return firstDayWeekday >= calendar.firstWeekday ? firstDayWeekday - calendar.firstWeekday : 7 - firstDayWeekday
    }

    static private func daysAfterInMonth(inMonth: NSDate, calendar: NSCalendar) -> Int {
        let days = inMonth.numberOfDaysInMonth() + daysBeforeInMonth(inMonth, calendar: calendar)
        return days % 7 != 0 ? 7 - days % 7 : 0
    }

    var dateSelectedHandler: ((date:NSDate) -> ())?
    var cellConfigurationHandler: ((cell:UICollectionViewCell) -> ())?

    var month: NSDate? {
        didSet {
            collectionView.reloadData()
        }
    }

    var startDate: NSDate?
    var endDate: NSDate?
    var selectedDate: NSDate?

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
            return MXMonthView.titleFormatter.stringFromDate(month)
        }
        return ""
    }

    private func dayTitle(dayIndex: Int) -> String {
        var index = calendar.firstWeekday + dayIndex - 1
        while index > 6 {
            index -= 7
        }
        let title = MXMonthView.dayFormatter.shortWeekdaySymbols[index]
        return title
    }
}

extension MXMonthView {

    // MARK: Custom cells

    private func monthTitleCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MXTextCell.defaultReuseIdentifier, forIndexPath: indexPath) as! MXTextCell
        cell.text = monthTitle()
        return cell
    }

    private func dayTitleCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MXTextCell.defaultReuseIdentifier, forIndexPath: indexPath) as! MXTextCell
        cell.text = dayTitle(indexPath.row)
        return cell
    }

    private func emptyCell(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(MXEmptyCell.defaultReuseIdentifier, forIndexPath: indexPath)
    }

    private func dayCell(collectionView: UICollectionView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MXDayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! MXDayCell
        cell.date = date
        cell.selectedDate = selectedDate
        cellConfigurationHandler?(cell: cell)
        return cell
    }

    private func inactiveDayCell(collectionView: UICollectionView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MXInactiveDayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! MXInactiveDayCell
        cell.date = date
        return cell
    }
}

extension MXMonthView: UICollectionViewDataSource {

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
        } else {
            return daysBeforeInMonth(month) + month.numberOfDaysInMonth() + daysAfterInMonth(month)
        }
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

extension MXMonthView: UICollectionViewDelegate {

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)

        if let dayCell = collectionView.cellForItemAtIndexPath(indexPath) as? MXDayCell, date = dayCell.date {
            dateSelectedHandler?(date: date)
        }
    }
}

extension MXMonthView: UICollectionViewDelegateFlowLayout {

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
//
// Created by Maxim Pervushin on 22/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol MonthViewControllerDelegate: class {

    func monthViewController(controller: MonthViewController, didPickDate date: NSDate)
}

class MonthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dayLabels: [UILabel]!

    static let defaultStoryboardID = "MonthViewController"

    weak var monthViewControllerDelegate: MonthViewControllerDelegate?

    var minDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    var maxDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    var month: NSDate? {
        didSet {
            updateUI()
        }
    }

    var date: NSDate? {
        didSet {
            updateUI()
        }
    }

    var calendar = NSCalendar.currentCalendar() {
        didSet {
            updateUI()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        if let month = month {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "LLLL YYYY"
            titleLabel?.text = dateFormatter.stringFromDate(month)
        } else {
            titleLabel?.text = ""
        }

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: NSDate())
        components.day = calendar.firstWeekday - 1
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EE"
        let offsetComponents = NSDateComponents()
        offsetComponents.day = 1
        var date = calendar.dateFromComponents(components)
        for i in 0 ... 6 {
            let label = dayLabels[i]
            label.text = formatter.stringFromDate(date!)
            date = calendar.dateByAddingComponents(offsetComponents, toDate: date!, options: [])
        }

        collectionView?.reloadData()
    }

    private func daysBeforeInMonth(inMonth: NSDate) -> Int {
        let firstDayWeekday = inMonth.firstDayOfMonth().weekday()
        return firstDayWeekday >= calendar.firstWeekday ? firstDayWeekday - calendar.firstWeekday : 7 - firstDayWeekday
    }

    private func daysAfterInMonth(inMonth: NSDate) -> Int {
        let days = inMonth.numberOfDaysInMonth() + daysBeforeInMonth(inMonth)
        return days % 7 != 0 ? 7 - days % 7 : 0
    }
}

extension MonthViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let currentMonth = month else {
            return 0
        }

        return daysBeforeInMonth(currentMonth) + currentMonth.numberOfDaysInMonth() + daysAfterInMonth(currentMonth)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! DayCell
        guard let currentMonth = month else {
            return cell
        }

        let daysBefore = daysBeforeInMonth(currentMonth)
        let cellDate = currentMonth.firstDayOfMonth().dateByAddingDays(indexPath.row - daysBefore)
        cell.date = cellDate

        if let minDate = minDate where cellDate < minDate {
            cell.dayLabel.textColor = UIColor.lightGrayColor()
            cell.enabled = false
        } else if let maxDate = maxDate where cellDate > maxDate {
            cell.dayLabel.textColor = UIColor.lightGrayColor()
            cell.enabled = false
        } else if indexPath.row < daysBefore {
            cell.dayLabel.textColor = UIColor.lightGrayColor()
            cell.enabled = false
        } else if indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth() {
            cell.dayLabel.textColor = UIColor.lightGrayColor()
            cell.enabled = false
        } else if let date = date where cellDate.dateByIgnoringTime() == date.dateByIgnoringTime() {
            cell.dayLabel.textColor = UIColor.greenColor()
            cell.enabled = true
        } else if cellDate.dateByIgnoringTime() == NSDate().dateByIgnoringTime() {
            cell.dayLabel.textColor = UIColor.redColor()
            cell.enabled = true
        } else if cellDate.isSaturday() || cellDate.isSunday() {
            cell.dayLabel.textColor = UIColor.darkGrayColor()
            cell.enabled = true
        } else {
            cell.dayLabel.textColor = UIColor.blackColor()
            cell.enabled = true
        }

        return cell
    }
}

extension MonthViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? DayCell where cell.enabled else {
            return
        }

        if let date = cell.date {
            monthViewControllerDelegate?.monthViewController(self, didPickDate: date)
        }
    }
}

extension MonthViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = CGFloat(collectionView.frame.size.width / 7)
        return CGSizeMake(side, side)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}


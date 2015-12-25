//
//  DatePickerViewController.swift
//  DatePickerResearch
//
//  Created by Maxim Pervushin on 21/12/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func todayButtonAction(sender: AnyObject) {
        scrollToDate(NSDate(), animated: true)
    }

    var selectedDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    var minDate = NSDate(timeIntervalSince1970: 0) {
        didSet {
            updateUI()
        }
    }

    var maxDate = NSDate() {
        didSet {
            updateUI()
        }
    }

    var calendar = NSCalendar.currentCalendar() {
        didSet {
            updateUI()
        }
    }

    private var minYear: Int {
        return NSCalendar.currentCalendar().components([.Year], fromDate: minDate).year
    }

    private var minMonth: Int {
        return NSCalendar.currentCalendar().components([.Month], fromDate: minDate).month
    }

    private var maxYear: Int {
        return NSCalendar.currentCalendar().components([.Year], fromDate: maxDate).year
    }

    private var maxMonth: Int {
        return NSCalendar.currentCalendar().components([.Month], fromDate: maxDate).month
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToDate(NSDate(), animated: false)
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        collectionView.reloadData()
    }

    private func indexPathForDate(date: NSDate) -> NSIndexPath? {
        if date < minDate || date > maxDate {
            return nil
        }

        let month = date.month()
        let year = date.year()
        let section = 12 * (year - minYear) + month - 1
        let row = date.day() + daysBeforeInMonth(date) - 1
        return NSIndexPath(forRow: row, inSection: section)
    }

    private func scrollToDate(date: NSDate, animated: Bool) {
        if !isViewLoaded() {
            return
        }

        guard let indexPath = indexPathForDate(date) else {
            return
        }

        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredVertically, animated: animated)
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

extension DatePickerViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 12 * (maxYear - minYear + 1) - minMonth - (12 - maxMonth) + 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let minMonth = minDate.firstDayOfMonth()
        let currentMonth = minMonth.dateByAddingMonths(section)
        return daysBeforeInMonth(currentMonth) + currentMonth.numberOfDaysInMonth() + daysAfterInMonth(currentMonth)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DayCell.defaultReuseIdentifier, forIndexPath: indexPath) as! DayCell

        let minMonth = minDate.firstDayOfMonth()
        let currentMonth = minMonth.dateByAddingMonths(indexPath.section)
        let daysBefore = daysBeforeInMonth(currentMonth)
        let cellDate = currentMonth.firstDayOfMonth().dateByAddingDays(indexPath.row - daysBefore)
        cell.date = cellDate

        if indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth() {
            cell.dayLabel.textColor = UIColor.clearColor()
        } else if cellDate < minDate || cellDate > maxDate {
            cell.dayLabel.textColor = UIColor.lightGrayColor()
        } else if cellDate.isSaturday() || cellDate.isSunday() {
            cell.dayLabel.textColor = UIColor.blueColor()
        } else {
            cell.dayLabel.textColor = UIColor.blackColor()
        }

        if let selectedDate = selectedDate where cellDate.dateByIgnoringTime() == selectedDate.dateByIgnoringTime()
                && !(indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth()) {
            cell.highlightColor = UIColor.greenColor()
        } else if cellDate.dateByIgnoringTime() == NSDate().dateByIgnoringTime()
                && !(indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth()) {
            cell.highlightColor = UIColor.redColor()
        } else {
            cell.highlightColor = UIColor.clearColor()
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: MonthCollectionReusableView.defaultHeaderReuseIdentifier, forIndexPath: indexPath) as! MonthCollectionReusableView
            let firstDayOfMonth = minDate.dateByAddingMonths(indexPath.section)
            header.month = firstDayOfMonth
            return header
        } else {
            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "LineCollectionReusableViewFooter", forIndexPath: indexPath)
        }
    }
}

extension DatePickerViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let date = (collectionView.cellForItemAtIndexPath(indexPath) as! DayCell).date {
            selectedDate = date
            print("selectedDate:\(selectedDate)")
        }
    }
}

extension DatePickerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = CGFloat(collectionView.frame.size.width / 7)
        return CGSizeMake(side, side)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width
        let height = CGFloat(width / 7)
        return CGSizeMake(width, height * 1.25)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.size.width
        let height = 1.0 / UIScreen.mainScreen().scale
        return CGSizeMake(width, height)
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

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

    @IBAction func pickButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    var selectedDate: NSDate? {
        didSet {
            if let selectedDate = selectedDate {
                scrollToDate(selectedDate)
            }
        }
    }

    var minDate: NSDate {
        didSet {
            updateUI()
        }
    }

    var minYear: Int {
        return NSCalendar.currentCalendar().components([.Year], fromDate: minDate).year
    }

    var maxDate: NSDate {
        didSet {
            updateUI()
        }
    }

    var maxYear: Int {
        return NSCalendar.currentCalendar().components([.Year], fromDate: maxDate).year
    }

    var configuration = DatePickerConfiguration() {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        collectionView.reloadData()
    }

    private func scrollToDate(date: NSDate) {
        if !isViewLoaded() {
            return
        }

        let month = date.month()
        let year = date.year()
        let section = ((year - minYear) * 12) + month
        if section <= collectionView?.numberOfSections() {
            let indexPath = NSIndexPath(forRow: 1, inSection: section - 1)
            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: false)
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedDate = NSDate()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        minDate = NSDate(timeIntervalSince1970: 0)
        maxDate = NSDate()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required override init?(coder aDecoder: NSCoder) {
        minDate = NSDate(timeIntervalSince1970: 0)
        maxDate = NSDate()
        super.init(coder: aDecoder)
    }
}

extension DatePickerViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let numberOfSections = 12 * (maxYear - minYear)
        return numberOfSections
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startDate = NSDate(year: minYear, month: 1, day: 1)
        let firstDayOfMonth = startDate.dateByAddingMonths(section)
        let addingPrefixDaysWithMonthDyas = (firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - NSCalendar.currentCalendar().firstWeekday)
        let addingSuffixDays = addingPrefixDaysWithMonthDyas % 7
        var numberOfItems = addingPrefixDaysWithMonthDyas
        if addingSuffixDays != 0 {
            numberOfItems = numberOfItems + (7 - addingSuffixDays)
        }

        return numberOfItems
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DateCell.defaultReuseIdentifier, forIndexPath: indexPath) as! DateCell

        let calendarStartDate = NSDate(year: minYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(indexPath.section)
        let prefixDays = (firstDayOfThisMonth.weekday() - NSCalendar.currentCalendar().firstWeekday)

        if indexPath.row >= prefixDays {
//            cell.isCellSelectable = true
            let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row - prefixDays)
            let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth() - 1)

//            cell.currentDate = currentDate
//            cell.dateLabel.text = "\(currentDate.day())"
            cell.date = currentDate

            if selectedDate == currentDate {
                print("selectedDate:\(selectedDate)")
                cell.backgroundColor = configuration.selectedDayBackgroundColor
                cell.dateLabel.textColor = configuration.selectedDayColor
            } else {
                cell.backgroundColor = UIColor.whiteColor()
                cell.dateLabel.textColor = configuration.activeDayColor
            }


//            if arrSelectedDates.contains(currentDate) {
//                cell.selectedForLabelColor(dateSelectionColor)
//            } else {
//                cell.deSelectedForLabelColor(weekdayTintColor)
//
            if currentDate.isSaturday() {
                cell.dateLabel.textColor = configuration.weekendDayColor
            }
            if currentDate.isSunday() {
                cell.dateLabel.textColor = configuration.weekendDayColor
            }
            if (currentDate > nextMonthFirstDay) {
//                    cell.isCellSelectable = false
                cell.dateLabel.textColor = configuration.inactiveDayColor
            }
//                if currentDate.isToday() {
//                    cell.setTodayCellColor(todayTintColor)
//                }
//
//            }
        } else {
//            cell.isCellSelectable = false
            let previousDay = firstDayOfThisMonth.dateByAddingDays(-(prefixDays - indexPath.row))
//            cell.currentDate = previousDay
//            cell.dateLabel.text = "\(previousDay.day())"
            cell.date = previousDay
            cell.dateLabel.textColor = configuration.inactiveDayColor
//            cell.lblDay.layer.backgroundColor = UIColor.whiteColor().CGColor
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: MonthCollectionReusableView.defaultHeaderReuseIdentifier, forIndexPath: indexPath) as! MonthCollectionReusableView

        let firstDayOfMonth = minDate.dateByAddingMonths(indexPath.section)

        header.month = firstDayOfMonth
        return header
    }

}

extension DatePickerViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let date = (collectionView.cellForItemAtIndexPath(indexPath) as! DateCell).date {
            selectedDate = date
            collectionView.reloadData()
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

struct DatePickerConfiguration {

//    var minDate: NSDate?
//    var maxDate: NSDate?
    var selectedDayColor = UIColor.redColor()
    var selectedDayBackgroundColor = UIColor.greenColor()
    var weekendDayColor = UIColor.blueColor()
    var activeDayColor = UIColor.blackColor()
    var inactiveDayColor = UIColor.clearColor()

//    var minYear: Int {
//        return 2015
//    }
//
//    var endYear: Int {
//        return 2016
//    }
}
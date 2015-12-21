//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class MonthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var dayLabels: [UILabel]!

    var month: NSDate? {
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
            dateFormatter.dateFormat = "MMMM, YYYY"
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

    }
}

extension MonthViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let startDate = NSDate(year: configuration.startYear, month: 1, day: 1)
        guard let startDate = month?.firstDayOfMonth() else {
            return 0
        }
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

        guard let calendarStartDate = month?.firstDayOfMonth() else {
            return cell
        }

//        let calendarStartDate = NSDate(year: configuration.startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths(indexPath.section)
        let prefixDays = (firstDayOfThisMonth.weekday() - NSCalendar.currentCalendar().firstWeekday)

        if indexPath.row >= prefixDays {
//            cell.isCellSelectable = true
            let currentDate = firstDayOfThisMonth.dateByAddingDays(indexPath.row - prefixDays)
            let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth() - 1)

//            cell.currentDate = currentDate
//            cell.dateLabel.text = "\(currentDate.day())"
            cell.date = currentDate

//            if selectedDate == currentDate {
//                print("selectedDate:\(selectedDate)")
//                cell.backgroundColor = configuration.selectedDayBackgroundColor
//                cell.dateLabel.textColor = configuration.selectedDayColor
//            } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.dateLabel.textColor = UIColor.blackColor()
//            }


//            if arrSelectedDates.contains(currentDate) {
//                cell.selectedForLabelColor(dateSelectionColor)
//            } else {
//                cell.deSelectedForLabelColor(weekdayTintColor)
//
            if currentDate.isSaturday() {
                cell.dateLabel.textColor = UIColor.blueColor()
            }
            if currentDate.isSunday() {
                cell.dateLabel.textColor = UIColor.blueColor()
            }
            if (currentDate > nextMonthFirstDay) {
//                    cell.isCellSelectable = false
                cell.dateLabel.textColor = UIColor.clearColor()
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
            cell.dateLabel.textColor = UIColor.clearColor()
//            cell.lblDay.layer.backgroundColor = UIColor.whiteColor().CGColor
        }
        return cell
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

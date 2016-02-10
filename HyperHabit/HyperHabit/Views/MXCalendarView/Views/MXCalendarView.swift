//
// Created by Maxim Pervushin on 14/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

public class MXCalendarView: UIView {

    // MARK: MXCalendarView @IB

    @IBOutlet weak var collectionView: UICollectionView?

    // MARK: MXCalendarView public

    var dateSelectedHandler: ((date:NSDate) -> Void)?
    var cellConfigurationHandler: ((cell:UICollectionViewCell) -> Void)?
    var willDisplayMonthHandler: ((month:NSDate) -> Void)?

    var calendar = NSCalendar.currentCalendar() {
        didSet {
            updateUI()
        }
    }

    var startDate = NSDate(timeIntervalSince1970: 0) {
        didSet {
            updateUI()
        }
    }

    var endDate = NSDate() {
        didSet {
            updateUI()
        }
    }

    var selectedDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    func scrollToDate(date: NSDate, animated: Bool) {
        if let indexPath = indexPathForDate(date) {
            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
        }
    }

    public func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView?.reloadData()
        }
    }

    // MARK: MXCalendarView private

    private func indexPathForDate(date: NSDate) -> NSIndexPath? {
        guard let _ = collectionView else {
            return nil
        }
        let adjustedDate = date.dateByIgnoringTime()
        if adjustedDate < startDate || adjustedDate > endDate {
            return nil
        }
        let section = adjustedDate.year() - startYear
        var row = adjustedDate.month() - 1
        if section == 0 {
            row -= startMonth
        }

        return NSIndexPath(forRow: row, inSection: section)
    }

    private var startYear: Int {
        return calendar.component(.Year, fromDate: startDate)
    }

    private var startMonth: Int {
        return calendar.component(.Month, fromDate: startDate)
    }

    private var endYear: Int {
        return calendar.component(.Year, fromDate: endDate)
    }

    private var endMonth: Int {
        return calendar.component(.Month, fromDate: endDate)
    }
}

extension MXCalendarView: UICollectionViewDataSource {

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return endYear - startYear + 1
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 12 - startMonth + 1

        } else if section == numberOfSectionsInCollectionView(collectionView) - 1 {
            return endMonth

        } else {
            return 12
        }
    }

    private func monthAtIndexPath(indexPath: NSIndexPath) -> NSDate {
        guard let collectionView = collectionView else {
            return NSDate(timeIntervalSince1970: 0)
        }
        var monthToAdd = indexPath.row
        if indexPath.section > 0 {
            for section in 0 ... indexPath.section - 1 {
                monthToAdd += collectionView.numberOfItemsInSection(section)
            }
        }
        return startDate.firstDayOfMonth().dateByAddingMonths(monthToAdd)
    }

    private func dateSelected(date: NSDate) {
        selectedDate = date
        dateSelectedHandler?(date: date)
    }

    private func cellConfiguration(cell: UICollectionViewCell) {
        if let dayCell = cell as? MXDayCell {
            cellConfigurationHandler?(cell: dayCell)
        }
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MXMonthCell.defaultReuseIdentifier, forIndexPath: indexPath) as! MXMonthCell
        cell.monthView?.calendar = calendar
        cell.monthView?.startDate = startDate
        cell.monthView?.endDate = endDate
        cell.monthView?.selectedDate = selectedDate
        cell.monthView?.month = monthAtIndexPath(indexPath)
        cell.monthView?.dateSelectedHandler = dateSelected
        cell.monthView?.cellConfigurationHandler = cellConfiguration
        return cell
    }
}

extension MXCalendarView: UICollectionViewDelegate {

    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        willDisplayMonthHandler?(month: monthAtIndexPath(indexPath))
    }
}

extension MXCalendarView: UICollectionViewDelegateFlowLayout {

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.width)
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

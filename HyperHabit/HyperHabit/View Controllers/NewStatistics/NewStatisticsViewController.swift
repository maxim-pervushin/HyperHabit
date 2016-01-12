//
// Created by Maxim Pervushin on 12/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class NewStatisticsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var selectedDate: NSDate? {
        didSet {
            updateUI()
            if let selectedDate = selectedDate {
                scrollToDate(selectedDate, animated: false)
            }
        }
    }

    var minDate = NSDate().dateByAddingMonths(-3) {
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

    private let dataSource = NewStatisticsDataSource(dataProvider: App.dataProvider)

    private var minYear: Int {
        return calendar.components([.Year], fromDate: minDate).year
    }

    private var minMonth: Int {
        return calendar.components([.Month], fromDate: minDate).month
    }

    private var maxYear: Int {
        return calendar.components([.Year], fromDate: maxDate).year
    }

    private var maxMonth: Int {
        return calendar.components([.Month], fromDate: maxDate).month
    }

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.collectionView.reloadData()
        }
    }

    private func indexPathForDate(date: NSDate) -> NSIndexPath? {
        if date.dateByIgnoringTime() < minDate.dateByIgnoringTime() || date.dateByIgnoringTime() > maxDate.dateByIgnoringTime() {
            return nil
        }

        let month = date.month()
        let year = date.year()
        let section = 12 * (year - minYear) + (month - minMonth)
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

        collectionView.layoutIfNeeded()
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

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(ThemeManager.changedNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ThemeManager.changedNotification, object: nil)
    }

    private func commonInit() {
//        transitioningDelegate = self
//        modalPresentationStyle = .Custom
//        modalPresentationCapturesStatusBarAppearance = true
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.reloadData()
        if let selectedDate = selectedDate {
            scrollToDate(selectedDate, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }
}

extension NewStatisticsViewController: UICollectionViewDataSource {

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

        let reports = dataSource.reportsForDate(cellDate)
        var allTotal = 0
        var allDone = 0
        for report in reports {
            allTotal += report.habitRepeatsTotal
            allDone += report.repeatsDone
        }

        if allDone == 0 {
            cell.highlightColor = UIColor.clearColor()
//            cell.highlightColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        } else if allDone == allTotal {
            cell.highlightColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        } else {
            cell.highlightColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        }

        if indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth() {
            cell.highlightColor = UIColor.clearColor()
            cell.dayLabel.textColor = UIColor.clearColor()
        } else if cellDate < minDate || cellDate > maxDate {
            cell.highlightColor = UIColor.clearColor()
            cell.dayLabel.textColor = App.themeManager.theme.inactiveTextColor
        } else if cellDate.isSaturday() || cellDate.isSunday() {
            cell.dayLabel.textColor = UIColor.blueColor()
        } else {
            cell.dayLabel.textColor = App.themeManager.theme.textColor
        }

//        if let selectedDate = selectedDate where cellDate.dateByIgnoringTime() == selectedDate.dateByIgnoringTime()
//                && !(indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth()) {
//            cell.highlightColor = UIColor.greenColor()
//        } else if cellDate.dateByIgnoringTime() == NSDate().dateByIgnoringTime()
//                && !(indexPath.row < daysBefore || indexPath.row >= daysBefore + currentMonth.numberOfDaysInMonth()) {
//            cell.highlightColor = UIColor.redColor()
//        } else {
//            cell.highlightColor = UIColor.clearColor()
//        }


        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: MonthCollectionReusableView.defaultHeaderReuseIdentifier, forIndexPath: indexPath) as! MonthCollectionReusableView
            let firstDayOfMonth = minDate.dateByAddingMonths(indexPath.section)
            header.month = firstDayOfMonth
            return header
        } else {
            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: LineCollectionReusableView.defaultFooterReuseIdentifier, forIndexPath: indexPath)
        }
    }
}

extension NewStatisticsViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let date = (collectionView.cellForItemAtIndexPath(indexPath) as! DayCell).date {
            print("\(dataSource.reportsForDate(date))")
//            selectedDate = date
//            finished?(date)
        }
    }
}

extension NewStatisticsViewController: UICollectionViewDelegateFlowLayout {

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
        let height = LineCollectionReusableView.defaultHeight
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

extension NewStatisticsViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}
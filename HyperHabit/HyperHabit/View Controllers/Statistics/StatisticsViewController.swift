//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!

    private let dataSource = StatisticsDataSource(dataProvider: App.dataProvider)
    private var selectedDate: NSDate?

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            if let monthYear = self.calendarView.presentedDate?.convertedDate()?.monthYear {
                self.titleLabel.text = monthYear
            } else {
                self.titleLabel.text = ""
            }
            self.calendarView.contentController.refreshPresentedMonth()
        }
    }

    private func loadReports() {
        let calendar = NSCalendar.currentCalendar()

        let components = calendar.components([.Year, .Month, .WeekOfMonth], fromDate: calendarView.presentedDate.convertedDate()!)

        // Start of the month.
        components.day = 1
        let monthStartDate = calendar.dateFromComponents(components)!

        // Start of the next month.
        components.month += 1
        let monthEndDate = calendar.dateFromComponents(components)!

        dataSource.loadReportsFiltered(nil, fromDate: monthStartDate, toDate: monthEndDate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadReports()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let statisticsForDateViewController = segue.destinationViewController as? StatisticsForDateViewController {
            statisticsForDateViewController.date = selectedDate
        }
    }
}

extension StatisticsViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}

extension StatisticsViewController: CVCalendarViewDelegate {

    func presentationMode() -> CalendarMode {
        return .MonthView
    }

    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }

    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }

    func presentedDateUpdated(date: CVDate) {
        loadReports()
    }

    func didSelectDayView(dayView: DayView, animationDidFinish: Bool) {
        guard let date = dayView.date.convertedDate() else  {
            return
        }

        selectedDate = date
        performSegueWithIdentifier("ShowStatisticsForDate", sender: self)
    }

    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }

    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        guard let date = dayView.date.convertedDate() else {
            return []
        }

        let reports = dataSource.reportsForDate(date)
        if reports.count == 0 {
            dayView.backgroundColor = UIColor.whiteColor()
            return []
        }

        var allTotal = 0
        var allDone = 0
        for report in reports {
            allTotal += report.habitRepeatsTotal
            allDone += report.repeatsDone
        }

        dayView.layer.cornerRadius = 3
        if allDone == 0 {
            dayView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.2)
        } else if allDone == allTotal {
            dayView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        } else {
            dayView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        }
        return []
    }
}

extension StatisticsViewController: CVCalendarMenuViewDelegate {

    func firstWeekday() -> Weekday {
        return .Monday
    }

    func dayOfWeekFont() -> UIFont {
        return UIFont.systemFontOfSize(12)
    }

    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
}

extension StatisticsViewController: CVCalendarViewAppearanceDelegate {

    func dayLabelWeekdayFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }

    func dayLabelPresentWeekdayFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }

    func dayLabelPresentWeekdayBoldFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }

    func dayLabelPresentWeekdayHighlightedFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }

    func dayLabelPresentWeekdaySelectedFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }

    func dayLabelWeekdayHighlightedFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }

    func dayLabelWeekdaySelectedFont() -> UIFont {
        return UIFont.systemFontOfSize(18)
    }
}


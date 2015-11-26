//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    @IBAction func segmentedControlValueChanged(sender: AnyObject) {
        dataSource.loadReportsFiltered(segmentedControl.selectedSegmentIndex == 0 ? nil : Habit(name: "Meditate", repeatsTotal: 0), fromDate: self.calendarView.presentedDate!.convertedDate()!.firstDayOfMonth!, toDate: self.calendarView.presentedDate!.convertedDate()!.firstDayOfMonth!.nextMonth!)
    }

    private let dataSource = StatisticsDataSource(dataManager: App.dataManager)
    private var selectedDate: NSDate?

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let monthYear = self.calendarView.presentedDate?.convertedDate()?.monthYear {
                self.titleLabel.text = monthYear
            } else {
                self.titleLabel.text = ""
            }
            self.calendarView.contentController.refreshPresentedMonth()
//            self.calendarView.validated = true
//            self.calendarView.commitCalendarViewUpdate()
//            self.calendarView.commitCalendarViewUpdate()
//            self.calendarMenuView.commitMenuViewUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
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

extension StatisticsViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

    // TODO: Change font. It is 'Avenir' by-default.

    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }

    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Monday
    }

    // MARK: Optional methods

    func shouldAutoSelectDayOnWeekChange() -> Bool {
        return false
    }

    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }


    func shouldShowWeekdaysOut() -> Bool {
        return true
    }

    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }

    func didSelectDayView(dayView: CVCalendarDayView) {
        guard let date = dayView.date.convertedDate() else  {
            return
        }

        selectedDate = date
        performSegueWithIdentifier("ShowStatisticsForDate", sender: self)
    }

    func presentedDateUpdated(date: CVDate) {
//        titleLabel.text = "\(date.convertedDate())"
        updateUI()
    }

    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }

    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        guard let date = dayView.date.convertedDate() else  {
            return false
        }

        let count = dataSource.reportsForDate(date).count
        dayView.backgroundColor = UIColor.whiteColor()
        return count > 0
    }

    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        guard let date = dayView.date.convertedDate() else {
//            dayView.layer.cornerRadius = 3
//            dayView.backgroundColor = UIColor.whiteColor()
            return []
        }

        let reports = dataSource.reportsForDate(date)
        var allTotal = 0
        var allDone = 0
        for report in reports {
            allTotal += report.habitRepeatsTotal
            allDone += report.repeatsDone
        }

        dayView.layer.cornerRadius = 3
        dayView.backgroundColor = allTotal == allDone ? UIColor.greenColor().colorWithAlphaComponent(0.2) : UIColor.redColor().colorWithAlphaComponent(0.2)
        return []
    }

    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }

    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15
    }

    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
}


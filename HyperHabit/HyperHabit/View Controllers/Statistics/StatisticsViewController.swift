//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    // MARK: StatisticsViewController @IB

    @IBOutlet weak var calendarView: MXCalendarView!

    // MARK: StatisticsViewController

    private let dataSource = StatisticsDataSource(dataProvider: App.dataProvider)
    private var selectedDate: NSDate?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
         calendarView?.scrollToDate(NSDate(), animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView?.cellConfigurationHandler = calendarViewCellConfiguration
        calendarView?.willDisplayMonthHandler = calendarViewWillDisplayMonth
    }

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.calendarView?.updateUI()
        }
    }

    private func calendarViewCellConfiguration(cell: UICollectionViewCell) {
        if let dayCell = cell as? MXDayCell, let date = dayCell.date {
            let reports = dataSource.reportsForDate(date)
            if reports.count > 0 {
                let completedCount = try! reports.reduce(0, combine: { if $1.completed { return $0 + 1 } else { return $0 } })
                if completedCount == reports.count {
                    cell.backgroundColor = UIColor.greenColor()
                } else {
                    cell.backgroundColor = UIColor.yellowColor()
                }
            } else {
                cell.backgroundColor = UIColor.clearColor()
            }
        }
    }

    private func calendarViewWillDisplayMonth(month: NSDate) {
        dataSource.loadReportsFiltered(nil, fromDate: month, toDate: month.dateByAddingMonths(1))
    }
}

extension StatisticsViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}


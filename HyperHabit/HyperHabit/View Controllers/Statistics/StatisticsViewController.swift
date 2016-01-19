//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, Themed {

    // MARK: StatisticsViewController @IB

    @IBOutlet weak var calendarView: MXCalendarView!

    // MARK: StatisticsViewController

    private let dataSource = StatisticsDataSource(dataProvider: App.dataProvider)
    private var selectedDate: NSDate?

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        calendarView?.scrollToDate(NSDate(), animated: false)
        updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView?.cellConfigurationHandler = calendarViewCellConfiguration
        calendarView?.willDisplayMonthHandler = calendarViewWillDisplayMonth
        dataSource.changedHandler = updateUI
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }

    deinit {
        themedDeinit()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        themedInit()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        themedInit()
    }

    private func updateUI() {
        print("updateUI")
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.calendarView?.updateUI()
        }
    }

    private func calendarViewCellConfiguration(cell: UICollectionViewCell) {
        if let dayCell = cell as? MXDayCell, let date = dayCell.date {
            let reports = dataSource.reportsForDate(date)
            if reports.counfontfontddt > 0 {
                let completedCount = try! reports.reduce(0, combine: {
                    if $1.completed {
                        return $0 + 1
                    } else {
                        return $0
                    }
                })
                if completedCount == reports.count {
                    dayCell.accessoryView?.color = UIColor.greenColor()
                } else if completedCount >= reports.count / 2 {
                    dayCell.accessoryView?.color = UIColor.yellowColor()
                } else {
                    dayCell.accessoryView?.color = UIColor.redColor()
                }
            } else {
                dayCell.accessoryView?.color = UIColor.clearColor()
            }
        }
    }

    private func calendarViewWillDisplayMonth(month: NSDate) {
        dataSource.month = month
    }
}

extension StatisticsViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}


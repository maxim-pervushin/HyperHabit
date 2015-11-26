//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class StatisticsDataSource: DataSource {

    private(set) var reports = [Report]() /*{
        didSet {
            print("\(reports)")
        }
    }*/

    func reportsForDate(date: NSDate) -> [Report] {
        var result = [Report]()
        for report in reports {
            if report.date.dateComponent == date.dateComponent {
                result.append(report)
            }
        }
//        print("reportsForDate(date: \(date.dateComponent) -> \(result)")
        return result
    }

    func loadReportsFiltered(habit: Habit?, fromDate: NSDate, toDate: NSDate) {
//        print("loadReportsFiltered(habit: \(habit), fromDate: \(fromDate), toDate: \(toDate)")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            () -> Void in
            self.reports = self.dataManager.reportsFiltered(habit, fromDate: fromDate, toDate: toDate)
            self.changesObserver?.observableChanged(self)
        }
    }
}

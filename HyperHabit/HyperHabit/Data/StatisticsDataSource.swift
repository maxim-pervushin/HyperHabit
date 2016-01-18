//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class StatisticsDataSource: DataSource {

    private(set) var reports = [Report]()

    func reportsForDate(date: NSDate) -> [Report] {
        var result = [Report]()
        for report in reports {
            if report.date.dateComponent == date.dateComponent {
                result.append(report)
            }
        }
        return result
    }

    func loadReportsFiltered(habit: Habit?, fromDate: NSDate, toDate: NSDate) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            () -> Void in
            self.reports = self.dataProvider.reportsFiltered(habit, fromDate: fromDate, toDate: toDate)
            self.changesObserver?.observableChanged(self)
        }
    }
}

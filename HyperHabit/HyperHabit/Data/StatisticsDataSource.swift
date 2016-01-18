//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class StatisticsDataSource/*: DataSource*/ {

    private let dataProvider: DataProvider
    private var reports = [Report]()

    var changedHandler: (Void -> Void)?

    var month: NSDate? {
        didSet {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                () -> Void in
                if let month = self.month {
                    self.reports = self.dataProvider.reportsFiltered(nil, fromDate: month, toDate: month.dateByAddingMonths(1))
                } else {
                    self.reports = []
                }
                self.changedHandler?()
            }
        }
    }

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func reportsForDate(date: NSDate) -> [Report] {
        var result = [Report]()
        for report in reports {
            if report.date.dateComponent == date.dateComponent {
                result.append(report)
            }
        }
        return result
    }
}

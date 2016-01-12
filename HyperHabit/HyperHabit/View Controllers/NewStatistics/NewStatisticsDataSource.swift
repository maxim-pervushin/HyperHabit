//
// Created by Maxim Pervushin on 12/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import Foundation

class NewStatisticsDataSource: DataSource {

    private(set) var reports = [Report]() {
        didSet {
            changesObserver?.observableChanged(self)
        }
    }

    func reportsForDate(date: NSDate) -> [Report] {
        return reports.filter({ return $0.date.dateComponent == date.dateComponent })
    }

    func reloadData() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            () -> Void in
            self.reports = self.dataProvider.reports;
        }
    }

    override init(dataProvider: DataProvider) {
        super.init(dataProvider: dataProvider)
        reloadData()
    }
}

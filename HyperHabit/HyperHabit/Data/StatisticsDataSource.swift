//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class StatisticsDataSource {

    private let dataProvider: DataProvider
    private let cache = NSCache()

    var changedHandler: (Void -> Void)? {
        didSet {
            changedHandler?()
        }
    }

    var month: NSDate? {
        didSet {
            if let month = month {
                let key = "\(month.year())-\(month.month())"
                if nil == cache.objectForKey(key) {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                        () -> Void in
                        let reports = self.dataProvider.reportsFiltered(nil, fromDate: month, toDate: month.dateByAddingMonths(1))
                        self.cache.setObject(reports, forKey: key)
                        self.changedHandler?()
                    }
                }
            }
        }
    }

    func reportsForDate(date: NSDate) -> [Report] {
        let key = "\(date.year())-\(date.month())"
        guard let cached = cache.objectForKey(key) as? [Report] else {
            return []
        }
        return cached.filter({ $0.date.day() == date.day() })
    }

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(DataManager.changedNotification, object: nil, queue: nil) {
            (notification: NSNotification) -> Void in
            self.cache.removeAllObjects()
            self.changedHandler?()
        }
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataManager.changedNotification, object: nil)
    }
}

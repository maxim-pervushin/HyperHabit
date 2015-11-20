//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class StatisticsDataSource: DataSource {

    func reportsForDate(date: NSDate) -> [Report] {
        return dataManager.reportsForDate(date)
    }
}

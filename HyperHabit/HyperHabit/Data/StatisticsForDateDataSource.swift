//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class StatisticsForDateDataSource: DataSource {

    func reportsForDate(date: NSDate) -> [Report] {
        return dataProvider.reportsForDate(date)
    }
}

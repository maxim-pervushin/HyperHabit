//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import XCTest

extension TodayDataSourceTestCase {

    func test_todayReports() {
        XCTAssertEqual([], dataSource.todayReports)

        let habit1 = Habit(name: "Habit 1", repeatsTotal: 1)
        dataSource.dataManager.saveHabit(habit1)
        let habit2 = Habit(name: "Habit 2", repeatsTotal: 2)
        dataSource.dataManager.saveHabit(habit2)

        XCTAssertEqual(2, dataSource.todayReports.count)

    }
}

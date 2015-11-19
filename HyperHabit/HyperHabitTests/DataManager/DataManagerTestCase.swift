//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import XCTest
@testable import HyperHabit


class DataManagerTestCase: XCTestCase {

    internal var dataManager = DataManager(storage: MemoryStorage())

    internal func sortHabits(habits: [Habit]) -> [Habit] {
        return habits.sort({ $0.hashValue > $1.hashValue })
    }

    internal func sortReports(reports: [Report]) -> [Report] {
        return reports.sort({ $0.hashValue > $1.hashValue })
    }

    override func setUp() {
        super.setUp()
        dataManager = DataManager(storage: MemoryStorage())
    }

    override func tearDown() {
        super.tearDown()
    }
}

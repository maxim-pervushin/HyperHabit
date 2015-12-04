//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import XCTest
@testable import HyperHabit

class TodayDataSourceTestCase: XCTestCase {

    internal var dataSource = ReportsByDateDataSource(dataProvider: DataManager(storage: MemoryStorage()))

    override func setUp() {
        super.setUp()
        dataSource = ReportsByDateDataSource(dataProvider: DataManager(storage: MemoryStorage()))
    }

    override func tearDown() {
        super.tearDown()
    }
}

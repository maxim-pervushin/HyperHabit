//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import XCTest

extension DataManagerTestCase {

    func test_deleteHabit() {

        let habit1 = Habit(name: "Habit 1", repeatsTotal: 1)
        dataManager.saveHabit(habit1)
        let habit2 = Habit(name: "Habit 2", repeatsTotal: 2)
        dataManager.saveHabit(habit2)
        XCTAssertEqual(Test.sortHabits([habit1, habit2]), Test.sortHabits(dataManager.habits))

        XCTAssertTrue(dataManager.deleteHabit(habit1))
        XCTAssertEqual([habit2], dataManager.habits)

        XCTAssertTrue(dataManager.deleteHabit(habit2))
        XCTAssertEqual([], dataManager.habits)
    }
}

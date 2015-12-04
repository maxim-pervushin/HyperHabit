//
// Created by Maxim Pervushin on 25/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import XCTest
@testable import HyperHabit

class HabitEditorTestCase: XCTestCase {

    internal var editor = HabitEditor()

    override func setUp() {
        super.setUp()
        editor = HabitEditor()
    }

    override func tearDown() {
        super.tearDown()
    }
}

extension HabitEditorTestCase {

    func test_canSave_noHabit() {
        XCTAssertEqual(false, editor.canSave)
    }

    func test_canSave_withHabit() {
        XCTAssertEqual(false, editor.canSave)
        editor.habit = Habit(name: "Foo", repeatsTotal: 1, active: true)
        XCTAssertEqual(false, editor.canSave)
    }

    func test_canSave_noHabit_nameInvalid() {
        XCTAssertEqual(false, editor.canSave)

        editor.repeatsTotal = 1

        editor.name = ""
        XCTAssertEqual(false, editor.canSave)

        editor.name = " "
        XCTAssertEqual(false, editor.canSave)

        editor.name = "  "
        XCTAssertEqual(false, editor.canSave)
    }

    func test_canSave_withHabit_nameInvalid() {
        XCTAssertEqual(false, editor.canSave)
        editor.habit = Habit(name: "Foo", repeatsTotal: 1, active: true)
        XCTAssertEqual(false, editor.canSave)

        editor.name = "Foo"
        XCTAssertEqual(false, editor.canSave)

        editor.name = ""
        XCTAssertEqual(false, editor.canSave)

        editor.name = " "
        XCTAssertEqual(false, editor.canSave)

        editor.name = "  "
        XCTAssertEqual(false, editor.canSave)
    }

    func test_canSave_noHabit_repeatsTotalInvalid() {
        XCTAssertEqual(false, editor.canSave)

        editor.name = "Foo"

        editor.repeatsTotal = 0
        XCTAssertEqual(false, editor.canSave)

        editor.repeatsTotal = -1
        XCTAssertEqual(false, editor.canSave)
    }

    func test_canSave_withHabit_repeatsTotalInvalid() {
        XCTAssertEqual(false, editor.canSave)
        editor.habit = Habit(name: "Foo", repeatsTotal: 1, active: true)
        XCTAssertEqual(false, editor.canSave)

        editor.repeatsTotal = 1
        XCTAssertEqual(false, editor.canSave)

        editor.repeatsTotal = 0
        XCTAssertEqual(false, editor.canSave)

        editor.repeatsTotal = -1
        XCTAssertEqual(false, editor.canSave)
    }

    func test_canSave_noHabit_validData() {
        XCTAssertEqual(false, editor.canSave)

        editor.name = "Foo"
        editor.repeatsTotal = 1
        XCTAssertEqual(true, editor.canSave)
    }

    func test_canSave_withHabit_validData() {
        XCTAssertEqual(false, editor.canSave)
        editor.habit = Habit(name: "Foo", repeatsTotal: 1, active: true)
        XCTAssertEqual(false, editor.canSave)

        editor.name = "Bar"
        XCTAssertEqual(true, editor.canSave)

        editor.name = "Foo"
        XCTAssertEqual(false, editor.canSave)

        editor.repeatsTotal = 2
        XCTAssertEqual(true, editor.canSave)
    }
}

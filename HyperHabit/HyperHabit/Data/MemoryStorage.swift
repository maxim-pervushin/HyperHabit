//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class MemoryStorage: DataProvider {

    // MARK: MemoryStorage

    private var _habits = Set<Habit>()
    private var _reports = Set<Report>()

    // MARK: DataProvider

    var habits: [Habit] {
        return Array(_habits)
    }

    func saveHabit(habit: Habit) -> Bool {
        _habits.insert(habit)
        return true
    }

    func deleteHabit(habit: Habit) -> Bool {
        _habits.remove(habit)
        return true
    }

    var reports: [Report] {
        return Array(_reports)
    }

    func reportsForDate(date: NSDate) -> [Report] {
        return Array(_reports)
    }

    func saveReport(report: Report) -> Bool {
        _reports.insert(report)
        return true
    }

    func deleteReport(report: Report) -> Bool {
        _reports.remove(report)
        return true
    }

}

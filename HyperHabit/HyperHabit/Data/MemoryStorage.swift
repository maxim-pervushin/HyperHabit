//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class MemoryStorage: DataProvider {

    // MARK: MemoryStorage

    private var _habitsById = [String: Habit]()
    private var _reportsById = [String: Report]()

    // MARK: DataProvider

    var habits: [Habit] {
        return Array(_habitsById.values)
    }

    func saveHabit(habit: Habit) -> Bool {
        _habitsById[habit.id] = habit
        return true
    }

    func deleteHabit(habit: Habit) -> Bool {
        _habitsById[habit.id] = nil
        return true
    }

    var reports: [Report] {
        return Array(_reportsById.values)
    }

    func reportsForDate(date: NSDate) -> [Report] {
        return Array(_reportsById.values)
    }

    func saveReport(report: Report) -> Bool {
        _reportsById[report.id] = report
        return true
    }

    func deleteReport(report: Report) -> Bool {
        _reportsById[report.id] = nil
        return true
    }
}

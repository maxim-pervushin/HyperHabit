//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class DataManager: DataProvider {

    private let storage: DataProvider

    init(storage: DataProvider) {
        self.storage = storage
    }

    // MARK: DataProvider

    var habits: [Habit] {
        return storage.habits
    }

    func saveHabit(habit: Habit) -> Bool {
        return storage.saveHabit(habit)
    }

    func deleteHabit(habit: Habit) -> Bool {
        return storage.deleteHabit(habit)
    }

    var reports: [Report] {
        return storage.reports
    }

    func reportsForDate(date: NSDate) -> [Report] {
        return storage.reportsForDate(date)
    }

    func saveReport(report: Report) -> Bool {
        return storage.saveReport(report)
    }

    func deleteReport(report: Report) -> Bool {
        return storage.deleteReport(report)
    }

}

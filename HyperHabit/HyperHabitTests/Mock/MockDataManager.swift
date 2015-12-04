//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class MockDataManager {
}

extension MockDataManager: DataProvider {

    var habits: [Habit] {
        return []
    }
    func saveHabit(habit: Habit) -> Bool {
        return false
    }

    func deleteHabit(habit: Habit) -> Bool {
        return false
    }
    var reports: [Report] {
        return []
    }
    func reportsForDate(date: NSDate) -> [Report] {
        return []
    }

    func saveReport(report: Report) -> Bool {
        return false
    }

    func deleteReport(report: Report) -> Bool {
        return false
    }

    func reportsFiltered(habit: Habit?, fromDate: NSDate, toDate: NSDate) -> [Report] {
        return []
    }
}
//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

protocol DataProvider {

    var habits: [Habit] { get }

    func saveHabit(habit: Habit) -> Bool

    func deleteHabit(habit: Habit) -> Bool

    var reports: [Report] { get }

    func reportsForDate(date: NSDate) -> [Report]

    func saveReport(report: Report) -> Bool

    func deleteReport(report: Report) -> Bool
}

//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class TodayDataSource: DataSource {

    var date = NSDate() {
        didSet {
            changesObserver?.observableChanged(self)
        }
    }

    var hasPreviousDate: Bool {
        return date.dateComponent != NSDate(timeIntervalSince1970: 0).dateComponent
    }

    var hasNextDate: Bool {
        return date.dateComponent != NSDate().dateComponent
    }

    func previousDate() {
        date = date.previousDay
    }

    func nextDate() {
        date = date.nextDay
    }

    var reports: [Report] {
        let habits = dataManager.habits
        var reports = dataManager.reportsForDate(date)
        for habit in habits {
            var createReport = true
            for report in reports {
                // TODO: Find better solution
                if report.habitName == habit.name {
                    createReport = false
                    break;
                }
            }
            if createReport {
                reports.append(Report(habit: habit, repeatsDone: 0, date: date))
            }
        }
        return reports.sort({ $0.habitName > $1.habitName })
    }

    var completedReports: [Report] {
        do {
            return try reports.filter {
                return $0.completed
            }
        } catch {
            return []
        }
    }

    var incompletedReports: [Report] {
        do {
            return try reports.filter {
                return !$0.completed
            }
        } catch {
            return []
        }
    }

    func saveReport(report: Report) -> Bool {
        return dataManager.saveReport(report)
    }
}

//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class TodayDataSource: DataSource {

    var todayReports: [Report] {
        let habits = dataManager.habits
        var reports = dataManager.reportsForDate(NSDate())
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
                reports.append(Report(habit: habit, repeatsDone: 0, date: NSDate()))
            }
        }
        return reports.sort({ $0.habitName > $1.habitName })
    }

    func saveReport(report: Report) -> Bool {
        return dataManager.saveReport(report)
    }
}

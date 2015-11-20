//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import XCTest

extension DataManagerTestCase {

    func test_reportsForDate() {

        XCTAssertEqual([], dataManager.reportsForDate(NSDate()))

        let report1 = Report(habitName: "Habit 1", habitRepeatsTotal: 1, repeatsDone: 1, date: NSDate.distantPast())
        dataManager.saveReport(report1)
        let report2 = Report(habitName: "Habit 2", habitRepeatsTotal: 2, repeatsDone: 1, date: NSDate.distantPast())
        dataManager.saveReport(report2)
        XCTAssertEqual(Test.sortReports([report1, report2]), Test.sortReports(dataManager.reports))
        XCTAssertEqual([], dataManager.reportsForDate(NSDate()))

        let report3 = Report(habitName: "Habit 1", habitRepeatsTotal: 1, repeatsDone: 1, date: NSDate())
        dataManager.saveReport(report3)
        let report4 = Report(habitName: "Habit 2", habitRepeatsTotal: 2, repeatsDone: 1, date: NSDate())
        dataManager.saveReport(report4)
        XCTAssertEqual(Test.sortReports([report1, report2, report3, report4]), Test.sortReports(dataManager.reports))
        XCTAssertEqual(Test.sortReports([report3, report4]), Test.sortReports(dataManager.reportsForDate(NSDate())))


        let report5 = Report(habitName: "Habit 1", habitRepeatsTotal: 1, repeatsDone: 1, date: NSDate.distantFuture())
        dataManager.saveReport(report5)
        let report6 = Report(habitName: "Habit 2", habitRepeatsTotal: 2, repeatsDone: 1, date: NSDate.distantFuture())
        dataManager.saveReport(report6)
        XCTAssertEqual(Test.sortReports([report1, report2, report3, report4, report5, report6]), Test.sortReports(dataManager.reports))
        XCTAssertEqual(Test.sortReports([report3, report4]), Test.sortReports(dataManager.reportsForDate(NSDate())))
    }
}

//
// Created by Maxim Pervushin on 20/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class Test {

    static internal func sortHabits(habits: [Habit]) -> [Habit] {
        return habits.sort({ $0.hashValue > $1.hashValue })
    }

    static internal func sortReports(reports: [Report]) -> [Report] {
        return reports.sort({ $0.hashValue > $1.hashValue })
    }
}

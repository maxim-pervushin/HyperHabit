//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class HabitListDataSource: DataSource {

    var habits: [Habit] {
        return dataManager.habits
    }

    func saveHabit(habit: Habit) -> Bool {
        return dataManager.saveHabit(habit)
    }

    func deleteHabit(habit: Habit) -> Bool {
        return dataManager.deleteHabit(habit)
    }
}

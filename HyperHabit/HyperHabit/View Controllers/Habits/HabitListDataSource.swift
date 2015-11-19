//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class HabitListDataSource {

    var habits: [Habit] {
        return App.dataManager.habits
    }

    func saveHabit(habit: Habit) -> Bool {
        return App.dataManager.saveHabit(habit)
    }

    func deleteHabit(habit: Habit) -> Bool {
        return App.dataManager.deleteHabit(habit)
    }
}

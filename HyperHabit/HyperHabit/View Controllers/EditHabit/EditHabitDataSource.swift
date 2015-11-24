//
// Created by Maxim Pervushin on 24/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class EditHabitDataSource: DataSource {

    func saveHabit(habit: Habit) -> Bool {
        return dataManager.saveHabit(habit)
    }
}

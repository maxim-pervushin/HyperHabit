//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

struct App {

    static var dataManager: DataManager {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataManager! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.instance = DataManager(storage: MemoryStorage())
            // Add some fake data
            Static.instance.saveHabit(Habit(name: "Eat vegetables", repeatsTotal: 1));
            Static.instance.saveHabit(Habit(name: "Drink more water", repeatsTotal: 3));
        }

        return Static.instance
    }
}

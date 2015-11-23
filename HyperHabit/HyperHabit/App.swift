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
            if let contentDirectoryURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.hyperhabit") {
                Static.instance = DataManager(storage: PlistStorage(contentDirectory: contentDirectoryURL.absoluteString))

                // Add some fake data
                if Static.instance.habits.count == 0 {

                    Static.instance.saveHabit(Habit(name: "Meditate vegetables", repeatsTotal: 2))
                    Static.instance.saveHabit(Habit(name: "Eat vegetables", repeatsTotal: 1))
                    Static.instance.saveHabit(Habit(name: "Drink more water", repeatsTotal: 1))
                    Static.instance.saveHabit(Habit(name: "Exercise", repeatsTotal: 1))
                    Static.instance.saveHabit(Habit(name: "Read", repeatsTotal: 1))

                    let habits = Static.instance.habits

                    var date = NSDate()
                    for var i = 0; i < 10; i++ {
                        print("Generating reports for: \(date)")
                        for habit in habits {
                            let report = Report(habit: habit, repeatsDone: Int(arc4random_uniform(UInt32(habit.repeatsTotal))) + 1, date: date)
                            Static.instance.saveReport(report)
                        }
                        date = date.previousDay
                    }
                }
            } else {
                print("ERROR: Unable to initialize DataManager")
            }
        }

        return Static.instance
    }
}

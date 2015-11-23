//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import Parse

struct App {

    static var dataManager: DataManager {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataManager! = nil
        }

        dispatch_once(&Static.onceToken) {
            if let contentDirectory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.hyperhabit")?.path {
                Static.instance = DataManager(storage: PlistStorage(contentDirectory: contentDirectory))

            Parse.enableDataSharingWithApplicationGroupIdentifier("group.hyperhabit")
            // TODO: Move real AppId and ClientKey to config file
            Parse.setApplicationId("aQOwqENo97J1kytqlvN6uTdDPfhtuG5Ups5gDNjg", clientKey: "UNmINBV5r7dmN6Fnm4bOrknrfAT2ciZmS7YFd77z")
            Static.instance = DataManager(storage: ParseStorage(contentDirectory: contentDirectory))

            // Add some fake data
            if Static.instance.habits.count == 0 {

                Static.instance.saveHabit(Habit(name: "Meditate", repeatsTotal: 2))
                Static.instance.saveHabit(Habit(name: "Eat vegetables", repeatsTotal: 1))
                Static.instance.saveHabit(Habit(name: "Drink more water", repeatsTotal: 1))
                Static.instance.saveHabit(Habit(name: "Exercise", repeatsTotal: 1))
                Static.instance.saveHabit(Habit(name: "Read", repeatsTotal: 1))

                let habits = Static.instance.habits

                var counter = 0
                var date = NSDate()
                for var i = 0; i < 10; i++ {
                    print("Generating reports for: \(date)")
                    for habit in habits {
                        let report = Report(habit: habit, repeatsDone: Int(arc4random_uniform(UInt32(habit.repeatsTotal))) + 1, date: date)
                        Static.instance.saveReport(report)
                        counter++
                    }
                    date = date.previousDay
                }
                print("Fake reports: \(counter)")

            }
            } else {
                print("ERROR: Unable to initialize DataManager")
            }
        }

        return Static.instance
    }
}

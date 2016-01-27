//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

extension Report {

    convenience init?(parseObject: PFObject) {
        if let
        id = parseObject["identifier"] as? String,
        habitName = parseObject["habitName"] as? String,
        habitRepeatsTotal = parseObject["habitRepeatsTotal"] as? Int,
        repeatsDone = parseObject["repeatsDone"] as? Int,
        dateComponent = parseObject["date_dateComponent"] as? String,
        date = NSDate.dateWithDateComponent(dateComponent) {
            self.init(id: id, habitName: habitName, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: repeatsDone, date: date)
        } else {
            return nil
        }
    }

    func getParseObjectForUser(user: PFUser) -> PFObject {
        let query = PFQuery(className: "Report")
        query.whereKey("identifier", equalTo: id)
        query.whereKey("user", equalTo: user)
        if let existingObject = try? query.getFirstObject() {
            existingObject["habitName"] = habitName
            existingObject["habitRepeatsTotal"] = habitRepeatsTotal
            existingObject["repeatsDone"] = repeatsDone
            existingObject["date_dateComponent"] = date.dateComponent
            return existingObject
        }
        let newObject = PFObject(className: "Report")
        newObject["identifier"] = id
        newObject["habitName"] = habitName
        newObject["habitRepeatsTotal"] = habitRepeatsTotal
        newObject["repeatsDone"] = repeatsDone
        newObject["date_dateComponent"] = date.dateComponent
        newObject["user"] = user
        return newObject
    }
}
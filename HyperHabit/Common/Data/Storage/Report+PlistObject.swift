//
// Created by Maxim Pervushin on 03/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

extension Report {

    convenience init?(packed: [String:AnyObject]) {
        if let
        id = packed["id"] as? String,
        habitName = packed["habitName"] as? String,
        habitRepeatsTotal = packed["habitRepeatsTotal"] as? Int,
        repeatsDone = packed["repeatsDone"] as? Int,
        dateComponent = packed["date_dateComponent"] as? String,
        date = NSDate.dateWithDateComponent(dateComponent) {
            self.init(id: id, habitName: habitName, habitRepeatsTotal: habitRepeatsTotal, repeatsDone: repeatsDone, date: date)
        } else {
            return nil
        }
    }

    var packed: [String:AnyObject] {
        return [
                "id": id,
                "habitName": habitName,
                "habitRepeatsTotal": habitRepeatsTotal,
                "repeatsDone": repeatsDone,
                "date_dateComponent": date.dateComponent,
        ]
    }
}

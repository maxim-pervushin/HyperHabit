//
// Created by Maxim Pervushin on 03/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

extension Habit {

    convenience init?(packed: [String:AnyObject]) {
        if let
        id = packed["id"] as? String,
        name = packed["name"] as? String,
        repeatsTotal = packed["repeatsTotal"] as? Int,
        active = packed["active"] as? Bool {
            self.init(id: id, name: name, repeatsTotal: repeatsTotal, active: active)
        } else {
            return nil
        }
    }

    var packed: [String:AnyObject] {
        return [
                "id": id,
                "name": name,
                "repeatsTotal": repeatsTotal,
                "active": active
        ]
    }
}

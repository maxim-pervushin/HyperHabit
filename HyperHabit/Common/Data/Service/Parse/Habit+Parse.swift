//
// Created by Maxim Pervushin on 04/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

extension Habit {

    convenience init?(parseObject: PFObject) {
        if let
        id = parseObject["identifier"] as? String,
        name = parseObject["name"] as? String,
        definition = parseObject["definition"] as? String,
        repeatsTotal = parseObject["repeatsTotal"] as? Int,
        active = parseObject["active"] as? Bool {
            self.init(id: id, name: name, definition: definition, repeatsTotal: repeatsTotal, active: active)
        } else {
            return nil
        }
    }

    func getParseObjectForUser(user: PFUser) -> PFObject {
        let idQuery = PFQuery(className: "Habit")
        idQuery.whereKey("identifier", equalTo: id)
        let nameQuery = PFQuery(className: "Habit")
        nameQuery.whereKey("name", equalTo: name)
        let query = PFQuery.orQueryWithSubqueries([idQuery, nameQuery])
        query.whereKey("user", equalTo: user)
        if let existingObject = try? query.getFirstObject() {
            existingObject["name"] = name
            existingObject["definition"] = definition
            existingObject["repeatsTotal"] = repeatsTotal
            existingObject["active"] = active
            existingObject["user"] = user
            return existingObject
        }
        let newObject = PFObject(className: "Habit")
        newObject["identifier"] = id
        newObject["name"] = name
        newObject["definition"] = definition
        newObject["repeatsTotal"] = repeatsTotal
        newObject["active"] = active
        newObject["user"] = user
        return newObject
    }
}

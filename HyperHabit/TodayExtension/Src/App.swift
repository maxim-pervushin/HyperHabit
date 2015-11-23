//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

struct App {

    static var dataManager: DataManager {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataManager! = nil
        }

        dispatch_once(&Static.onceToken) {


            if let contentDirectory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.hyperhabit")?.path {
                Parse.enableDataSharingWithApplicationGroupIdentifier("group.hyperhabit", containingApplication: "com.maximpervushin.HyperHabit")
                // TODO: Move real AppId and ClientKey to config file
                Parse.setApplicationId("aQOwqENo97J1kytqlvN6uTdDPfhtuG5Ups5gDNjg", clientKey: "UNmINBV5r7dmN6Fnm4bOrknrfAT2ciZmS7YFd77z")
                Static.instance = DataManager(storage: ParseStorage(contentDirectory: contentDirectory))

//                Static.instance = DataManager(storage: PlistStorage(contentDirectory: contentDirectory))
            } else {
                print("ERROR: Unable to initialize DataManager")
            }
        }

        return Static.instance
    }
}

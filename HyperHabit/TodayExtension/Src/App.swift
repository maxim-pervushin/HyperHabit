//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

struct App {

    static let groupIdentifier = "group.hyperhabit"
    static let containingApplicationIdentifier = "com.maximpervushin.HyperHabit"
    static let applicationId = "aQOwqENo97J1kytqlvN6uTdDPfhtuG5Ups5gDNjg"
    static let clientKey = "UNmINBV5r7dmN6Fnm4bOrknrfAT2ciZmS7YFd77z"

    static var dataProvider: DataProvider {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataProvider! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.instance = ParseStorage(groupIdentifier: groupIdentifier, containingApplicationIdentifier: containingApplicationIdentifier, applicationId: applicationId, clientKey: clientKey)
        }

        return Static.instance
    }

    /*
    static var dataManager: DataManager {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataManager! = nil
        }

        dispatch_once(&Static.onceToken) {
            if let parseStorage = ParseStorage(groupIdentifier: groupIdentifier, containingApplicationIdentifier: containingApplicationIdentifier, applicationId: applicationId, clientKey: clientKey) {
                Static.instance = DataManager(storage: parseStorage)
                parseStorage.changesObserver = Static.instance
            } else {
                print("ERROR: Unable to initialize DataManager")
            }
        }

        return Static.instance
    }
    */
}

extension ParseStorage {

    convenience init?(groupIdentifier: String, containingApplicationIdentifier: String, applicationId: String, clientKey: String) {
        if let contentDirectory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)?.path {
            Parse.enableDataSharingWithApplicationGroupIdentifier(groupIdentifier, containingApplication: containingApplicationIdentifier)
            Parse.setApplicationId(applicationId, clientKey: clientKey)
            self.init(contentDirectory: contentDirectory)
        } else {
            print("ERROR: Unable to initialize ParseStorage")
            return nil
        }
    }
}

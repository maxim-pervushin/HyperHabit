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
            if let contentDirectory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)?.path {
                let cache = PlistCache(contentDirectory: contentDirectory)
                let service = ParseService(applicationId: applicationId, clientKey: clientKey)
                Static.instance = DataManager(cache: cache, service: service)
            } else {
                print("ERROR: Unable to initialize ParseStorage")
            }
        }

        return Static.instance
    }
}

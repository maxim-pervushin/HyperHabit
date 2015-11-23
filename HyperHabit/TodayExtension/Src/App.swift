//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct App {

    static var dataManager: DataManager {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataManager! = nil
        }

        dispatch_once(&Static.onceToken) {
            if let contentDirectoryURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.hyperhabit") {
                Static.instance = DataManager(storage: PlistStorage(contentDirectory: contentDirectoryURL.absoluteString))
            } else {
                print("ERROR: Unable to initialize DataManager")
            }
        }

        return Static.instance
    }
}

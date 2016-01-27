//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct App {

    // MARK: App public

    static var dataProvider: DataProvider {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DataProvider! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.instance = DataManager(cache: cache, service: service)
        }

        return Static.instance
    }

    static var authenticated: Bool {
        if let parseService = service as? ParseService {
            return parseService.available
        }
        return false
    }

    // MARK: App private

    private static let groupIdentifier = "group.hyperhabit"

    private static var cache: Cache {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Cache! = nil
        }

        dispatch_once(&Static.onceToken) {
            if let contentDirectory = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)?.path {
                Static.instance = PlistCache(contentDirectory: contentDirectory)
            } else {
                print("ERROR: Unable to initialize cache")
            }
        }

        return Static.instance
    }

    private static var service: Service {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Service! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.instance = ParseService(applicationId: ParseServiceConfig.applicationId, clientKey: ParseServiceConfig.clientKey)
        }

        return Static.instance
    }
}

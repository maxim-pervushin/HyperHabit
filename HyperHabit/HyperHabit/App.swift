//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import Parse

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

    static func authenticate(viewController: UIViewController) {
        if let parseService = service as? ParseService {
             parseService.logIn(viewController)
        }
    }

    static func logOut(viewController: UIViewController) {
        if let parseService = service as? ParseService {
             parseService.logOut(viewController)
        }
    }

    // MARK: App private

    private static let groupIdentifier = "group.hyperhabit"
    private static let applicationId = "aQOwqENo97J1kytqlvN6uTdDPfhtuG5Ups5gDNjg"
    private static let clientKey = "UNmINBV5r7dmN6Fnm4bOrknrfAT2ciZmS7YFd77z"

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
            Static.instance = ParseService(applicationId: applicationId, clientKey: clientKey)
        }

        return Static.instance
    }
}

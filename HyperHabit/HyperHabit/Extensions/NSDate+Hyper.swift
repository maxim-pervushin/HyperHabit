//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

extension NSDate {

    private var dateComponentFormatter: NSDateFormatter {

        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var formatter: NSDateFormatter! = nil
        }

        dispatch_once(&Static.onceToken) {
            Static.formatter = NSDateFormatter()
            Static.formatter.dateFormat = "yyyy-MM-dd"
        }

        return Static.formatter
    }

    var dateComponent: String {
        return dateComponentFormatter.stringFromDate(self)
    }
}

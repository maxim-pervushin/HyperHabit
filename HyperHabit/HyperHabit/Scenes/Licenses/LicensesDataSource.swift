//
// Created by Maxim Pervushin on 05/02/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import Foundation

class LicensesDataSource {

    private var licenses = [
            ["name": "1001freedownloads-Full Set",
             "link": "http://www.1001FreeDownloads.com",
             "fileName": "1001Icons.txt",
            ],
            ["name": "DTFoundation",
             "link": "https://github.com/Cocoanetics/DTFoundation",
             "fileName": "DTFoundation.txt",
            ]
    ]

    var numberOfLicenses: Int {
        return licenses.count
    }

    func licenseAtIndex(index: Int) -> [String:String] {
        return licenses[index]
    }
}

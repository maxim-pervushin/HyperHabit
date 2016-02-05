//
// Created by Maxim Pervushin on 23/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class StatisticsForDateViewController: UIViewController {

    var date: NSDate?
    
    private let dataSource = StatisticsForDateDataSource(dataProvider: App.dataProvider)

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let date = date {
            print("reports: \(dataSource.reportsForDate(date))")
        }
    }
}

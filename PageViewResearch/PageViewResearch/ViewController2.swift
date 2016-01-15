//
// Created by Maxim Pervushin on 14/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var datePickerView: MXCalendarView?

    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView?.dateSelectedHandler = {
            date in
            print("selected: \(date)")
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        datePickerView?.selectedDate = NSDate().dateByAddingDays(-3)
        datePickerView?.scrollToDate(NSDate(), animated: false)
    }
}

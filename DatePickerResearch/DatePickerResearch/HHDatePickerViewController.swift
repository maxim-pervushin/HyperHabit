//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class HHDatePickerViewController: UIViewController {

    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pickButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    var minDate: NSDate? {
        didSet {
            updateData()
        }
    }

    var maxDate: NSDate? {
        didSet {
            updateData()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }

    private func updateData() {
        for childViewController in childViewControllers {
            if let calendarPageViewController = childViewController as? HHCalendarPageViewController {
                calendarPageViewController.minDate = minDate
                calendarPageViewController.maxDate = maxDate
            }
        }
    }
}

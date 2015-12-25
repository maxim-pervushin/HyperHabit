//
//  ViewController.swift
//  DatePickerResearch
//
//  Created by Maxim Pervushin on 21/12/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    @IBOutlet weak var dateLabel: UILabel!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        dateLabel.text = NSDate().description
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let datePickerViewController = segue.destinationViewController as? HHDatePickerViewController {
            datePickerViewController.minDate = NSDate().dateByAddingMonths(-12)
            datePickerViewController.maxDate = NSDate().dateByAddingMonths(1)
        } else if let datePickerViewController = segue.destinationViewController as? DatePickerViewController {
            datePickerViewController.minDate = NSDate(year: 2015, month: 1, day: 3)
            datePickerViewController.maxDate = NSDate(year: 2016, month: 2, day: 2)
            datePickerViewController.selectedDate = NSDate().dateByAddingDays(2)
        }
    }
}


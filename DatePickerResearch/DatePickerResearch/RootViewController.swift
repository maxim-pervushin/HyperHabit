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
}


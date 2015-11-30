//
// Created by Maxim Pervushin on 30/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import QuartzCore

class ReportCell: UITableViewCell {

    static let defaultReuseIdentifier = "ReportCell"

    @IBOutlet weak var completedIndicatorView: UIView! {
        didSet {
            completedIndicatorView?.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var habitNameLabel: UILabel!
    
    var report: Report? {
        didSet {
            completedIndicatorView?.backgroundColor = report?.completed == true ? UIColor.greenColor() : UIColor.redColor()
            habitNameLabel?.text = report?.habitName
        }
    }
}

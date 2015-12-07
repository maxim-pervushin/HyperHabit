//
// Created by Maxim Pervushin on 30/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import QuartzCore

class ReportCell: UITableViewCell {

    static let defaultReuseIdentifier = "ReportCell"

    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var habitNameLabel: UILabel!

    var report: Report? {
        didSet {
            checkboxImageView?.image = UIImage(named: report?.completed == true ? "CheckboxChecked" : "Checkbox")?.imageWithRenderingMode(.AlwaysTemplate)
            habitNameLabel?.text = report?.habitName
        }
    }
}

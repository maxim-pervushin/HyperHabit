//
// Created by Maxim Pervushin on 30/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell, MXReusableView {

    @IBOutlet weak var checkboxView: CheckboxView!
    @IBOutlet weak var habitNameLabel: UILabel!

    var report: Report? {
        didSet {
//            checkboxImageView?.image = UIImage(named: report?.completed == true ? "CheckboxChecked" : "Checkbox")?.imageWithRenderingMode(.AlwaysTemplate)
            checkboxView?.checked = report?.completed == true ? true : false
            habitNameLabel?.text = report?.habitName
        }
    }
}

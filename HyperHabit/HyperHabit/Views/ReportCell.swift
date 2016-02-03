//
// Created by Maxim Pervushin on 30/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell, MXReusableView {

    @IBOutlet weak var checkboxView: CheckboxView?
    @IBOutlet weak var habitNameLabel: UILabel?

    var report: Report? {
        didSet {
            checkboxView?.checked = report?.completed == true ? true : false
            habitNameLabel?.text = report?.habitName
        }
    }
}


class ReportWithDefinitionCell: UITableViewCell, MXReusableView {

    @IBOutlet weak var checkboxView: CheckboxView?
    @IBOutlet weak var habitNameLabel: UILabel?
    @IBOutlet weak var habitDefinitionLabel: UILabel?

    var report: Report? {
        didSet {
            checkboxView?.checked = report?.completed == true ? true : false
            habitNameLabel?.text = report?.habitName
            habitDefinitionLabel?.text = report?.habitDefinition
        }
    }
}

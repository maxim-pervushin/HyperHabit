//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class MonthCollectionReusableView: UICollectionReusableView {

    static let defaultHeaderReuseIdentifier = "MonthCollectionReusableViewHeader"
    static let defaultFooterReuseIdentifier = "MonthCollectionReusableViewFooter"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var dayTitleLabels: [UILabel]!

    var month: NSDate? {
        didSet {
            if let month = month {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMMM, YYYY"
                titleLabel?.text = dateFormatter.stringFromDate(month)
            } else {
                titleLabel?.text = ""
            }
            updateUI()
        }
    }

    func updateUI() {

        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: NSDate())
        components.day = calendar.firstWeekday - 1
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EE"
        let offsetComponents = NSDateComponents()
        offsetComponents.day = 1
        var date = calendar.dateFromComponents(components)
        for i in 0 ... 6 {
            let label = dayTitleLabels[i]
            label.text = formatter.stringFromDate(date!)
            date = calendar.dateByAddingComponents(offsetComponents, toDate: date!, options: [])
        }
    }
}

//
// Created by Maxim Pervushin on 22/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "DayCell"

    @IBOutlet weak var dayLabel: UILabel!

    var date: NSDate? {
        didSet {
            if let date = date {
                dayLabel?.text = "\(date.day())"
            } else {
                dayLabel?.text = ""
            }
        }
    }
}

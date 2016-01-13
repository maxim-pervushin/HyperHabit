//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "DayCell"

    @IBOutlet weak var dateLabel: UILabel!

    var date: NSDate? {
        didSet {
            if let date = date {
                dateLabel.text = "\(date.day())"
            } else {
                dateLabel.text = ""
            }
        }
    }
}

//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "DateCell"

    @IBOutlet weak var dateLabel: UILabel!

    var date: NSDate? {
        didSet {
            if let date = date {
                dateLabel?.text = "\(date.day())"
            } else {
                dateLabel?.text = ""
            }
        }
    }
}

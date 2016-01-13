//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class InactiveDayCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "InactiveDayCell"

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

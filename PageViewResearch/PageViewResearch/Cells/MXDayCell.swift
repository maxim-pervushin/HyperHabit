//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MXDayCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "MXDayCell"

    // TODO: UI_APPEARANCE_SELECTOR
    var todayDateColor = UIColor.greenColor()
    // TODO: UI_APPEARANCE_SELECTOR
    var selectedDateColor = UIColor.blueColor()

    @IBOutlet weak var dateLabel: UILabel!

    var date: NSDate? {
        didSet {
            updateUI()
        }
    }

    var selectedDate: NSDate? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        guard let date = date else {
            backgroundColor = UIColor.clearColor()
            dateLabel.text = ""
            return
        }

        if let selectedDate = selectedDate
        where (selectedDate.year() == date.year() && selectedDate.month() == date.month() && selectedDate.day() == date.day()) {
            backgroundColor = selectedDateColor
        } else if (date.isToday()) {
            backgroundColor = todayDateColor
        } else {
            backgroundColor = UIColor.clearColor()
        }

        dateLabel.text = "\(date.day())"
    }
}

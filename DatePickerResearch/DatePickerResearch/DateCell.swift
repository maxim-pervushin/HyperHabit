//
// Created by Maxim Pervushin on 21/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import QuartzCore

class DayCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "DayCell"

    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var dayLabel: UILabel!

    var date: NSDate? {
        didSet {
            updateUI()
        }
    }

    var highlightColor = UIColor.clearColor() {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        if let date = date {
            dayLabel.text = "\(date.day())"
        } else {
            dayLabel.text = ""
        }
        highlightView.backgroundColor = highlightColor
        bringSubviewToFront(dayLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        highlightView.layer.cornerRadius = max(highlightView.frame.size.height, highlightView.frame.size.width) / 2

    }
}

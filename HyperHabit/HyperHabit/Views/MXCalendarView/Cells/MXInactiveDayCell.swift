//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MXInactiveDayCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "MXInactiveDayCell"

    @IBOutlet weak var dateLabel: UILabel!

    var date: NSDate? {
        didSet {
            updateUI()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateAppearance()
    }

    private var _defaultBackgroundColor: UIColor?
    private var _defaultTextColor: UIColor?

    private func updateUI() {
        if let date = date {
            dateLabel.text = "\(date.day())"
        } else {
            dateLabel.text = ""
        }
        updateAppearance()
    }

    private func updateAppearance() {
        backgroundColor = _defaultBackgroundColor
        dateLabel?.textColor = _defaultTextColor
    }
}

extension MXInactiveDayCell {

    // MARK: - UIAppearance

    dynamic var defaultTextColor: UIColor? {
        // UI_APPEARANCE_SELECTOR
        get {
            return _defaultTextColor
        }
        set {
            _defaultTextColor = newValue
            updateAppearance()
        }
    }

    dynamic var defaultBackgroundColor: UIColor? {
        // UI_APPEARANCE_SELECTOR
        get {
            return _defaultBackgroundColor
        }
        set {
            _defaultBackgroundColor = newValue
            updateAppearance()
        }
    }
}
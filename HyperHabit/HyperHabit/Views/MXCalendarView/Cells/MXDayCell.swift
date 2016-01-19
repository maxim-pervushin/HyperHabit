//
// Created by Maxim Pervushin on 13/01/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MXDayCell: UICollectionViewCell, MXReusableView {

    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var accessoryView: MXAccessoryView?

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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateAppearance()
    }

    private var _defaultBackgroundColor: UIColor?
    private var _defaultTextColor: UIColor?
    private var _todayDateBackgroundColor: UIColor?
    private var _todayDateTextColor: UIColor?
    private var _selectedDateBackgroundColor: UIColor?
    private var _selectedDateTextColor: UIColor?

    private func updateUI() {
        if let date = date {
            dateLabel?.text = "\(date.day())"
        } else {
            dateLabel?.text = ""
        }

        updateAppearance()
    }

    private func updateAppearance() {
        if let date = date {
            if let selectedDate = selectedDate
            where (selectedDate.year() == date.year() && selectedDate.month() == date.month() && selectedDate.day() == date.day()) {
                backgroundColor = _selectedDateBackgroundColor
                dateLabel?.textColor = _selectedDateTextColor
            } else if (date.isToday()) {
                backgroundColor = _todayDateBackgroundColor
                dateLabel?.textColor = _todayDateTextColor
            } else {
                backgroundColor = _defaultBackgroundColor
                dateLabel?.textColor = _defaultTextColor
            }

        } else {
            backgroundColor = _defaultBackgroundColor
            dateLabel?.textColor = _defaultTextColor
        }

        if let dateLabel = dateLabel {
            bringSubviewToFront(dateLabel)
        }
    }
}

extension MXDayCell {

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

    dynamic var todayDateTextColor: UIColor? {
        // UI_APPEARANCE_SELECTOR
        get {
            return _todayDateTextColor
        }
        set {
            _todayDateTextColor = newValue
            updateAppearance()
        }
    }

    dynamic var todayDateBackgroundColor: UIColor? {
        // UI_APPEARANCE_SELECTOR
        get {
            return _todayDateBackgroundColor
        }
        set {
            _todayDateBackgroundColor = newValue
            updateAppearance()
        }
    }

    dynamic var selectedDateTextColor: UIColor? {
        // UI_APPEARANCE_SELECTOR
        get {
            return _selectedDateTextColor
        }
        set {
            _selectedDateTextColor = newValue
            updateAppearance()
        }
    }

    dynamic var selectedDateBackgroundColor: UIColor? {
        // UI_APPEARANCE_SELECTOR
        get {
            return _selectedDateBackgroundColor
        }
        set {
            _selectedDateBackgroundColor = newValue
            updateAppearance()
        }
    }
}
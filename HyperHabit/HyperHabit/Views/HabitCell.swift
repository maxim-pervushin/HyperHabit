//
// Created by Maxim Pervushin on 01/12/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class HabitCell: UITableViewCell, MXReusableView {

    @IBOutlet weak var nameLabel: UILabel!

    var habit: Habit? {
        didSet {
            nameLabel?.text = habit?.name
        }
    }
}



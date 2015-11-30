//
//  EditValueViewController.swift
//  InlineEditorResearch
//
//  Created by Maxim Pervushin on 30/11/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class EditValueCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func textFieldEditingChanged(sender: AnyObject) {
        print("editing changed: \(textField.text)")
    }
    
    var delegate: EditValueCellDelegate?
}

protocol EditValueCellDelegate {
    
}

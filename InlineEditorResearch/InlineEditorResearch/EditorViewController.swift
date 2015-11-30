//
//  EditorViewController.swift
//  InlineEditorResearch
//
//  Created by Maxim Pervushin on 30/11/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            backgroundView?.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField?.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil, usingBlock: keyboardWillShow)
    }
    
    // MARK: Keyboard notifications
    
    private func keyboardWillShow(notification: NSNotification) {
        if let endRect = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.CGRectValue() {
            bottomLayoutConstraint.constant = endRect.height + bottomLayoutConstraint.constant
            self.view.setNeedsLayout()
        }
    }
}

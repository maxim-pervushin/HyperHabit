//
//  FirstViewController.swift
//  PresentationResearch
//
//  Created by Maxim Pervushin on 08/12/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var editTextButton: UIButton!
    @IBOutlet weak var animateButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var animateButtonTrailingConstraint: NSLayoutConstraint!
    
    @IBAction func animateButtonAction(sender: AnyObject) {
        view.layoutIfNeeded()
        let leadingPriority = animateButtonLeadingConstraint.priority
        animateButtonLeadingConstraint.priority = animateButtonTrailingConstraint.priority
        animateButtonTrailingConstraint.priority = leadingPriority

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5,  options: [.CurveEaseInOut, .TransitionNone], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let editTextViewController = segue.destinationViewController as? EditTextViewController {
            editTextViewController.fromRect = editTextButton.frame
        }
    }
}


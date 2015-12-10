//
//  FirstViewController.swift
//  PresentationResearch
//
//  Created by Maxim Pervushin on 08/12/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var showThirdButton: UIButton!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let thirdViewController = segue.destinationViewController as? ThirdViewController {
            thirdViewController.fromRect = showThirdButton.frame
        }
    }
}


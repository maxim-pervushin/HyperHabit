//
// Created by Maxim Pervushin on 05/02/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class LicenseCell: UITableViewCell, MXReusableView {

    @IBOutlet weak var licenseTitleLabel: UILabel!
    @IBOutlet weak var licenseLinkButton: UIButton!
    @IBOutlet weak var licenseTextLabel: UILabel!

    @IBAction func licenseLinkButtonAction(sender: AnyObject) {
        if let linkString = license?["link"], link = NSURL(string: linkString) {
            UIApplication.sharedApplication().openURL(link)
        }
    }

    var license: [String:String]? {
        didSet {
            if let licenseTitle = license?["name"] {
                licenseTitleLabel?.text = licenseTitle
            } else {
                licenseTitleLabel?.text = ""
            }

            if let licenseLink = license?["link"] {
                licenseLinkButton?.setTitle(licenseLink, forState: .Normal)
            } else {
                licenseLinkButton?.setTitle("", forState: .Normal)
            }

            if let fileName = license?["fileName"],
            path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil),
            text = (try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)) as? String {
                licenseTextLabel?.text = text
            } else {
                licenseTextLabel?.text = ""
            }
        }
    }
}

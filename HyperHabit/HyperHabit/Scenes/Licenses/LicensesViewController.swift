//
// Created by Maxim Pervushin on 05/02/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class LicensesViewController: ThemedViewController {

    @IBOutlet weak var tableView: UITableView!

    private let dataSource = LicensesDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
}

extension LicensesViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfLicenses
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let license = dataSource.licenseAtIndex(indexPath.section)
        let cell = tableView.dequeueReusableCellWithIdentifier(LicenseCell.defaultReuseIdentifier, forIndexPath: indexPath) as! LicenseCell
        cell.license = license
        return cell
    }
}

//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    // MARK: TodayTableViewController @IB

    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var longDateLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!

    // MARK: TodayTableViewController

    private let dataSource = TodayDataSource(dataManager: App.dataManager)

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataSource.incompletedReports.count
        } else {
            return dataSource.completedReports.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReportCell.defaultReuseIdentifier, forIndexPath: indexPath) as! ReportCell
        let report = indexPath.section == 0 ? dataSource.incompletedReports[indexPath.row] : dataSource.completedReports[indexPath.row]
        cell.report = report
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let updatedReport = indexPath.section == 0 ? dataSource.incompletedReports[indexPath.row].completedReport : dataSource.completedReports[indexPath.row].incompletedReport
        if dataSource.saveReport(updatedReport) {
            tableView.reloadData()
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Completed"
        }
        return "Incompleted"
    }

}

extension TodayViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.dateLabel?.text = NSDate().mediumDateRelativeString
            self.longDateLabel?.text = NSDate().longDateString
            self.tableView?.reloadData()
        }
    }
}
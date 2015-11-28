//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class TodayTableViewController: UITableViewController {

    // MARK: TodayTableViewController

    private let dataSource = TodayDataSource(dataManager: App.dataManager)

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataSource.uncompletedReports.count
        } else {
            return dataSource.completedReports.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath)
        let report = indexPath.section == 0 ? dataSource.uncompletedReports[indexPath.row] : dataSource.completedReports[indexPath.row]
        cell.textLabel?.text = report.habitName
        cell.detailTextLabel?.text = "\(report.repeatsDone)/\(report.habitRepeatsTotal)"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let report = indexPath.section == 0 ? dataSource.uncompletedReports[indexPath.row] : dataSource.completedReports[indexPath.row]
        var updatedRepeatsDone = report.repeatsDone + 1
        if updatedRepeatsDone > report.habitRepeatsTotal {
            updatedRepeatsDone = 0
        }
        let updatedReport = Report(id: report.id, habitName: report.habitName, habitRepeatsTotal: report.habitRepeatsTotal, repeatsDone: updatedRepeatsDone, date: report.date)
        if dataSource.saveReport(updatedReport) {
//            tableView.beginUpdates()
//            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            tableView.endUpdates()
            tableView.reloadData()
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Completed"
        }
        return nil
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension TodayTableViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class TodayTableViewController: UITableViewController {

    // MARK: TodayTableViewController

    private let dataSource = TodayDataSource(dataManager: App.dataManager)

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.todayReports.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath)
        let report = dataSource.todayReports[indexPath.row]
        cell.textLabel?.text = report.habitName
        cell.detailTextLabel?.text = "\(report.repeatsDone)/\(report.habitRepeatsTotal)"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let report = dataSource.todayReports[indexPath.row]
        var updatedRepeatsDone = report.repeatsDone + 1
        if updatedRepeatsDone > report.habitRepeatsTotal {
            updatedRepeatsDone = 0
        }
        let updatedReport = Report(id: report.id, habitName: report.habitName, habitRepeatsTotal: report.habitRepeatsTotal, repeatsDone: updatedRepeatsDone, date: report.date)
        if dataSource.saveReport(updatedReport) {
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
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
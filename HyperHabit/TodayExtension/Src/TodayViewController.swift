//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Maxim Pervushin on 22/11/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var tableView: UITableView!

    private let dataSource = TodayDataSource(dataManager: App.dataManager)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        print("viewDidLoad")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        print("widgetPerformUpdateWithCompletionHandler")
        tableView.reloadData()
        completionHandler(NCUpdateResult.NewData)
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dataSource.todayReports.count:\(dataSource.todayReports.count)")
        return dataSource.todayReports.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath)
        let report = dataSource.todayReports[indexPath.row]
        cell.textLabel?.text = report.habitName
        cell.detailTextLabel?.text = "\(report.repeatsDone)/\(report.habitRepeatsTotal)"
        return cell
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
}

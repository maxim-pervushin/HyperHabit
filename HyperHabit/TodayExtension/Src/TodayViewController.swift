//
//  ReportsByDateViewController.swift
//  TodayExtension
//
//  Created by Maxim Pervushin on 22/11/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBAction func openApplicationButtonAction(sender: AnyObject) {
//        [self.extensionContext openURL:[NSURL URLWithString:@"timelogger://add"] completionHandler:nil];
        if let url = NSURL(string: "hyperhabit://open") {
            extensionContext?.openURL(url, completionHandler: nil)
        }
        print("Open Application");
    }
    
    private let dataSource = TodayDataSource(dataProvider: App.dataProvider)

    private var _heightConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint {
        get {
            if _heightConstraint == nil {
                _heightConstraint = NSLayoutConstraint(item: tableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: tableView.contentSize.height)
                tableView.addConstraint(_heightConstraint!)
            }
            return _heightConstraint!
        }
    }

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.heightConstraint.constant = self.tableView.contentSize.height
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        updateUI()
    }
}

extension TodayViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}

extension TodayViewController: NCWidgetProviding {

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        tableView.reloadData()
        updateUI()
        completionHandler(NCUpdateResult.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
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
        let report = indexPath.section == 0 ? dataSource.incompletedReports[indexPath.row] : dataSource.completedReports[indexPath.row]
        if report.habitDefinition.characters.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ReportWithDefinitionCell.defaultReuseIdentifier, forIndexPath: indexPath) as! ReportWithDefinitionCell
            cell.report = report
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(ReportCell.defaultReuseIdentifier, forIndexPath: indexPath) as! ReportCell
            cell.report = report
            return cell
        }
//        let cell = tableView.dequeueReusableCellWithIdentifier(ReportCell.defaultReuseIdentifier, forIndexPath: indexPath) as! ReportCell
//        let report = indexPath.section == 0 ? dataSource.incompletedReports[indexPath.row] : dataSource.completedReports[indexPath.row]
//        cell.report = report
//        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let updatedReport = indexPath.section == 0 ? dataSource.incompletedReports[indexPath.row].completedReport : dataSource.completedReports[indexPath.row].incompletedReport
        if dataSource.saveReport(updatedReport) {
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44;
    }
}

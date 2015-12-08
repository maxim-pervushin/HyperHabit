//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ReportsByDateViewController: UIViewController {

    // MARK: ReportsByDateViewController @IB

    @IBOutlet weak private var dateButton: UIButton!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var previousDayButton: UIButton!
    @IBOutlet weak private var nextDayButton: UIButton!

    @IBAction func previousDayButtonAction(sender: AnyObject) {
        dataSource.previousDate()
    }

    @IBAction func nextDayButtonAction(sender: AnyObject) {
        dataSource.nextDate()
    }

    // MARK: ReportsByDateViewController

    private let dataSource = ReportsByDateDataSource(dataProvider: App.dataProvider)

    private func updateUI() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dateButton?.setTitle(" \(self.dataSource.date.longDateRelativeString)", forState: .Normal)
            self.previousDayButton.hidden = !self.dataSource.hasPreviousDate
            self.nextDayButton.hidden = !self.dataSource.hasNextDate
            self.tableView?.reloadData()
        }
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
//        if let datePickerController = segue.destinationViewController as? DatePickerController {
//            datePickerController.datePickerDelegate = self
//            datePickerController.date = dataSource.date
//            datePickerController.maximumDate = NSDate()
//        }
        if let pickDateViewController = segue.destinationViewController as? PickDateViewController {
            pickDateViewController.datePickerDelegate = self
            pickDateViewController.date = dataSource.date
            pickDateViewController.maximumDate = NSDate()
        }
    }
}

extension ReportsByDateViewController: PickDateViewControllerDelegate {

    func pickDateViewController(controller: PickDateViewController, didPickDate date: NSDate) {
        dataSource.date = date
        dismissViewControllerAnimated(true, completion: nil)
    }

    func pickDateViewControllerDidCancel(controller: PickDateViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ReportsByDateViewController: UITableViewDataSource, UITableViewDelegate {

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

extension ReportsByDateViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}
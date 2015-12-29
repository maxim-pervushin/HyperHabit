//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class ReportsByDateViewController: UIViewController {

    // MARK: ReportsByDateViewController @IB

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var previousDayButton: UIButton!
    @IBOutlet weak var nextDayButton: UIButton!

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

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(ThemeManager.changedNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
            _ in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ThemeManager.changedNotification, object: nil)
    }

    private func commonInit() {
        subscribe()
    }

    deinit {
        unsubscribe()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return App.themeManager.theme.statusBarStyle
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let datePickerViewController = segue.destinationViewController as? DatePickerViewController {
            datePickerViewController.finished = {
                date in
                if let date = date {
                    self.dataSource.date = date
                }
                datePickerViewController.dismissViewControllerAnimated(true, completion: nil)
            }
//            datePickerViewController.minDate = NSDate().dateByAddingMonths(-2)
            datePickerViewController.maxDate = NSDate()
            datePickerViewController.selectedDate = dataSource.date
        }
    }
}

extension ReportsByDateViewController: UITableViewDataSource {

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

}

extension ReportsByDateViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let updatedReport = indexPath.section == 0 ? dataSource.incompletedReports[indexPath.row].completedReport : dataSource.completedReports[indexPath.row].incompletedReport
        if dataSource.saveReport(updatedReport) {
            tableView.reloadData()
        }
    }
}

extension ReportsByDateViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        updateUI()
    }
}
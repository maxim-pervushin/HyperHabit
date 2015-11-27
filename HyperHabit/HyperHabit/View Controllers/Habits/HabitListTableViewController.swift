//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class HabitListTableViewController: UITableViewController {

    // MARK: HabitListTableViewController @IB

    @IBAction func addButtonAction(sender: AnyObject!) {
        let newHabit = Habit(name: NSUUID().UUIDString, repeatsTotal: 1, active: true)
        if dataSource.saveHabit(newHabit) {
            tableView.reloadData()
        }
    }

    // MARK: HabitListTableViewController

    private let dataSource = HabitListDataSource(dataManager: App.dataManager)

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.habits.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HabitCell", forIndexPath: indexPath)
        let habit = dataSource.habits[indexPath.row]
        cell.textLabel?.text = habit.name
        cell.detailTextLabel?.text = "\(habit.repeatsTotal)"
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && dataSource.deleteHabit(dataSource.habits[indexPath.row]) {
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let editHabitViewController = segue.destinationViewController as? EditHabitViewController {
            if let selected = tableView.indexPathForSelectedRow {
                editHabitViewController.editor.habit = dataSource.habits[selected.row]
            } else {
                editHabitViewController.editor.habit = nil
            }
        }
    }
}

extension HabitListTableViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
//
// Created by Maxim Pervushin on 19/11/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class HabitListViewController: ThemedViewController {

    // MARK: HabitListViewController @IB

    @IBOutlet weak var tableView: UITableView!

    // MARK: HabitListViewController

    private let dataSource = HabitListDataSource(dataProvider: App.dataProvider)

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changesObserver = self
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let editHabitViewController = segue.destinationViewController as? EditHabitViewController {
            if let selectedRow = tableView.indexPathForSelectedRow?.row where selectedRow < dataSource.habits.count {
                editHabitViewController.editor.habit = dataSource.habits[selectedRow]
            } else {
                editHabitViewController.editor.habit = nil
            }
        }
    }
}

extension HabitListViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.habits.count + 1
    }

    private func addHabitCell(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("AddHabitCell", forIndexPath: indexPath)
    }

    private func habitCell(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let habit = dataSource.habits[indexPath.row]
        if habit.definition.characters.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(HabitWithDefinitionCell.defaultReuseIdentifier, forIndexPath: indexPath) as! HabitWithDefinitionCell
            cell.habit = habit
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(HabitCell.defaultReuseIdentifier, forIndexPath: indexPath) as! HabitCell
            cell.habit = habit
            return cell
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == dataSource.habits.count {
            return addHabitCell(tableView, forRowAtIndexPath: indexPath)
        } else {
            return habitCell(tableView, forRowAtIndexPath: indexPath)
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete && dataSource.deleteHabit(dataSource.habits[indexPath.row]) {
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.endUpdates()
        }
    }
}

extension HabitListViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("EditHabit", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension HabitListViewController: ChangesObserver {

    func observableChanged(observable: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
}
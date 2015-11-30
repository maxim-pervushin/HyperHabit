//
//  ViewController.swift
//  InlineEditorResearch
//
//  Created by Maxim Pervushin on 30/11/15.
//  Copyright © 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    private var values = ["Value 1", "Value 2", "Value 3", "Value 4"]

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count + 1
    }

    private func editorCell(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("EditorCell", forIndexPath: indexPath)
    }

    private func valueCell(tableView: UITableView, forRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ValueCell", forIndexPath: indexPath)
        cell.textLabel?.text = values[indexPath.row]
        return cell
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == values.count {
            return editorCell(tableView, forRowAtIndexPath: indexPath)
        } else {
            return valueCell(tableView, forRowAtIndexPath: indexPath)
        }
    }
}


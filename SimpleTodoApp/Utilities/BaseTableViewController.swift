//
//  BaseTableViewController.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-13.
//

import UIKit

class BaseTableViewController<Cell: BaseTableViewCell<Item>, Item>: UITableViewController {

    var items = [[Item]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let identifier = NSStringFromClass(Cell.self)
        self.tableView.register(Cell.self, forCellReuseIdentifier: identifier)
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(Cell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
        cell.settingModel = items[indexPath.section][indexPath.row]
        return cell
    }
}

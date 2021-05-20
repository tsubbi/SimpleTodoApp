//
//  TodoListTableViewController.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-17.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    var demoList = TodoList.init(withDemo: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let identifier = NSStringFromClass(ListTableViewCell.self)
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: identifier)
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        let addButon = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodoItem))
        self.navigationItem.setRightBarButton(addButon, animated: true)
        
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // if I don't check the state of table view's editing mode, this if will be triggered more often
        // this will cause a bug when the cell is selected, and swipe after, the cell will be deleted
        if self.tableView.isEditing,
           let selectedRows = self.tableView.indexPathsForSelectedRows {
            selectedRows.reversed().forEach {
                guard let priority = PriorityType(rawValue: $0[0]) else { return }
                demoList.removeItem(priority: priority, at: $0[1])
            }
            self.tableView.reloadData()
        }
        self.tableView.setEditing(editing, animated: true)
        self.navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = !editing })
        super.setEditing(editing, animated: animated)
        self.tableView.visibleCells.forEach({ $0.layoutIfNeeded() })
    }
    
    @objc func addTodoItem() {
        addEditTodo()
    }
    
    private func addEditTodo(item: Todo? = nil, positon: IndexPath? = nil) {
        
        let addVC = AddEditTableViewController()
        if let pos = positon, var todoItem = item {
            todoItem.indexPath = pos
            addVC.todo = todoItem
        } else {
            addVC.todo = item
        }
        addVC.dataPassingDelegate = self
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    // MARK: - Table View Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return PriorityType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let priority = PriorityType(rawValue: section) else { return 0 }
        return self.demoList.getList(priority: priority).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(ListTableViewCell.self)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ListTableViewCell
        if let priority = PriorityType(rawValue: indexPath.section) {
            let item = self.demoList.getItem(priority: priority, pos: indexPath.row)
            cell.settingModel = item
        }

        return cell
    }
    
    // MARK: - Table View Delegate
    // set section header title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PriorityType.allCases[section].title
    }
    
    // allow table view to move
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // set priority of the item
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let newPriority = PriorityType(rawValue: destinationIndexPath.section),
              let oldPriority = PriorityType(rawValue: sourceIndexPath.section) else { return }
        var todoItem = self.demoList.getItem(priority: oldPriority, pos: sourceIndexPath.row)
        todoItem.priority = newPriority
        self.demoList.removeItem(priority: oldPriority, at: sourceIndexPath.row)
        self.demoList.updateList(todoItem, at: destinationIndexPath.row)
    }
    
    // set leading swipe action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let priority = PriorityType(rawValue: indexPath.section) else { return nil }
        let title = self.demoList.getItem(priority: priority, pos: indexPath.row).isDone ? "UNCHECK" : "CHECK"
        let checkAction = UIContextualAction(style: .normal, title: title) { (_, _, success:(Bool) -> Void) in
            self.demoList.toggleItem(priority: priority, pos: indexPath.row)
            self.tableView.reloadData()
            success(true)
        }
        checkAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [checkAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isEditing {
            guard let priority = PriorityType(rawValue: indexPath.section) else { return }
            let todoItem = self.demoList.getItem(priority: priority, pos: indexPath.row)
            self.addEditTodo(item: todoItem, positon: indexPath)
        }
    }
}

extension TodoListTableViewController: UpdateTodoList {
    func addTodo(item: Todo) {
        self.demoList.addItem(item)
        self.tableView.reloadData()
    }
    
    func updateTodo(item: Todo) {
        var newTodo = item
        guard let indexPath = item.indexPath,
              let oldPriority = PriorityType(rawValue: indexPath.section)
        else { return }
        // clear indexPath for safety purpose
        newTodo.indexPath = nil
        if indexPath.section == item.priority.rawValue {
            // priority hasn't changed
            self.demoList.removeItem(priority: oldPriority, at: indexPath.row)
            self.demoList.updateList(item, at: indexPath.row)
        } else {
            // priority has changed
            self.demoList.removeItem(priority: oldPriority, at: indexPath.row)
            self.demoList.addItem(newTodo)
        }
        
        self.tableView.reloadData()
    }
}

//
//  TodoListTableViewController.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-17.
//

import UIKit

class TodoListTableViewController: BaseTableViewController<ListTableViewCell, Todo> {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = Todo.demoList
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        let addButon = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
        self.navigationItem.setRightBarButton(addButon, animated: true)
        
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        // if I don't check the state of table view's editing mode, this if will be triggered more often
        // this will cause a bug when the cell is selected, and swipe after, the cell will be deleted
        if self.tableView.isEditing,
           let selectedRows = self.tableView.indexPathsForSelectedRows {
            selectedRows.forEach {
                self.items[$0[0]].remove(at: $0[1])
            }
            self.tableView.reloadData()
        }
        self.tableView.setEditing(editing, animated: true)
        self.navigationItem.rightBarButtonItems?.forEach({ $0.isEnabled = !editing })
        super.setEditing(editing, animated: animated)
        self.tableView.visibleCells.forEach({ $0.layoutIfNeeded() })
    }
    
    @objc func addTodo() {
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
        guard let newPriority = PriorityType(rawValue: destinationIndexPath.section) else { return }
        var todoItem = self.items[sourceIndexPath.section][sourceIndexPath.row]
        todoItem.priority = newPriority
        self.items[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        self.items[destinationIndexPath.section].insert(todoItem, at: destinationIndexPath.row)
    }
    
    // set leading swipe action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkAction = UIContextualAction(style: .normal, title: self.items[indexPath.section][indexPath.row].isDone ? "UNCHECK" : "CHECK") { (_, _, success:(Bool) -> Void) in
            self.items[indexPath.section][indexPath.row].isDone.toggle()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            success(true)
        }
        checkAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [checkAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addEditTodo(item: self.items[indexPath.section][indexPath.row], positon: indexPath)
    }
}

extension TodoListTableViewController: UpdateTodoList {
    func onListUpdate(todo: Todo) {
        if let pos = todo.indexPath {
            // remove the previous item
            self.items[pos.section].remove(at: pos.row)
            var updateItem = todo
            // clear the index path
            updateItem.indexPath = nil
            // if the priority has changed, insert into new priority row, else update new item
            if pos.section == todo.priority.rawValue {
                self.items[pos.section].insert(updateItem, at: pos.row)
            } else {
                self.items[updateItem.priority.rawValue].append(updateItem)
            }
        } else {
            let index = todo.priority.rawValue
            self.items[index].append(todo)
        }
        self.tableView.reloadData()
    }
}

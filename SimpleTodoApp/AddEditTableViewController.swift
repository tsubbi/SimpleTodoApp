//
//  AddEditTableViewController.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-18.
//

import UIKit

class AddEditTableViewController: UITableViewController {
    enum TodoType {
        case add
        case update
    }
    
    var todo: Todo?
    private(set) var todoType: TodoType = .add
    weak var dataPassingDelegate: UpdateTodoList?
    private var cellConfig: [[AddEditCellSetting]] = []
    
    override func viewDidLoad() {
        if let todo = self.todo {
            cellConfig.append([AddEditCellSetting(value: todo.title, type: .title)])
            cellConfig.append([AddEditCellSetting(value: todo.description, type: .description)])
            cellConfig.append([AddEditCellSetting(value: "", intValue: todo.priority.rawValue, type: .priority)])
            self.todoType = .update
        } else {
            cellConfig.append([AddEditCellSetting(value: "", type: .title)])
            cellConfig.append([AddEditCellSetting(value: "", type: .description)])
            cellConfig.append([AddEditCellSetting(value: "", type: .priority)])
            self.todoType = .add
        }
        
        let identifier = NSStringFromClass(AddEditTableViewCell.self)
        self.tableView.register(AddEditTableViewCell.self, forCellReuseIdentifier: identifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func saveData() {
        if self.dataPassingDelegate != nil {
            var title = ""
            var description = ""
            var todoPriority: PriorityType = .low
            for i in 0...2 {
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: i)) as! AddEditTableViewCell
                switch i {
                case 0:
                    title = cell.titleTextField?.text ?? ""
                case 1:
                    description = cell.descriptionLabel?.text ?? ""
                case 2:
                    todoPriority = PriorityType(rawValue: cell.prioritySegment?.selectedSegmentIndex ?? 2) ?? .low
                default:
                    return
                }
            }
            var newTodo = Todo(title: title, description: description, priority: todoPriority)
            if let pos = self.todo?.indexPath {
                newTodo.indexPath = pos
            }
            if self.todoType == .add {
                self.dataPassingDelegate?.addTodo(item: newTodo)
            } else {
                self.dataPassingDelegate?.updateTodo(item: newTodo)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Table View DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellConfig.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfig[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = ["Title", "Description", "Priority"]
        return titles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(AddEditTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddEditTableViewCell
        cell.settingModel = cellConfig[indexPath.section][indexPath.row]
        return cell
    }
}

protocol UpdateTodoList: AnyObject {
    func addTodo(item: Todo)
    func updateTodo(item: Todo)
}

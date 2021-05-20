//
//  Todo.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-17.
//

import Foundation

struct TodoList {
    private var highList: [Todo] = []
    private var mediumList: [Todo] = []
    private var lowList: [Todo] = []
    
    init(withDemo: Bool) {
        if withDemo {
            Todo.demoList.forEach({ addItem($0) })
        } 
    }
    
    mutating func addItem(_ item: Todo) {
        switch item.priority {
        case .high:
            self.highList.append(item)
        case .medium:
            self.mediumList.append(item)
        case .low:
            self.lowList.append(item)
        }
    }
    
    func getList(priority: PriorityType) -> [Todo] {
        switch priority {
        case .high:
            return self.highList
        case .medium:
            return self.mediumList
        case .low:
            return self.lowList
        }
    }
    
    func getItem(priority: PriorityType, pos: Int) -> Todo {
        return self.getList(priority: priority)[pos]
    }
    
    mutating func toggleItem(priority: PriorityType, pos: Int) {
        switch priority {
        case .high:
            self.highList[pos].isDone.toggle()
        case .medium:
            self.mediumList[pos].isDone.toggle()
        case .low:
            self.lowList[pos].isDone.toggle()
        }
    }
    
    mutating func updateList(_ item: Todo, at index: Int) {
        switch item.priority {
        case .high:
            self.highList.insert(item, at: index)
        case .medium:
            self.mediumList.insert(item, at: index)
        case .low:
            self.lowList.insert(item, at: index)
        }
    }
    
    mutating func removeItem(priority: PriorityType, at index: Int) {
        switch priority {
        case .high:
            self.highList.remove(at: index)
        case .medium:
            self.mediumList.remove(at: index)
        case .low:
            self.lowList.remove(at: index)
        }
    }
}

struct Todo {
    var title: String
    var description: String
    var isDone: Bool = false
    var priority: PriorityType
    var indexPath: IndexPath? = nil
    
    static let demoList = [Todo(title: "sleep", description: "Praesent sed dictum nisl. Vivamus eu leo elit. Nullam felis metus, tincidunt ut mauris at, pulvinar faucibus neque.", priority: .low),
                           Todo(title: "cook", description: "Suspendisse eget nibh sit amet mauris efficitur viverra.", priority: .high),
                           Todo(title: "do chore", description: "Cras elementum vestibulum sollicitudin. Integer at arcu justo.", priority: .medium),
                           Todo(title: "chat with friend", description: "Duis condimentum tortor quis iaculis ultrices. Morbi eu maximus nunc.", priority: .medium),
                           Todo(title: "take a walk", description: "Integer non dui luctus, faucibus enim ac, congue felis.", priority: .low),
                           Todo(title: "watch animation", description: "Aenean pharetra, eros a ornare fermentum, est risus convallis justo", priority: .medium)]
}

enum PriorityType: Int, CaseIterable {
    case high
    case medium
    case low
    
    var title: String {
        switch self {
        case .high:
            return "High Priority"
        case .medium:
            return "Meidum Priority"
        case .low:
            return "Low Priority"
        }
    }
}

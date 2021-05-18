//
//  Todo.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-17.
//

import Foundation

struct Todo {
    var title: String
    var isDone: Bool = false
    var priority: PriorityType
    var indexPath: IndexPath? = nil
    
    static var demoList = [
        Todo(title: "sleep", priority: .low),
        Todo(title: "cook", priority: .high),
        Todo(title: "do chore", priority: .medium),
        Todo(title: "chat with friend", priority: .medium),
        Todo(title: "take a walk", priority: .low),
        Todo(title: "watch animation", priority: .medium)
    ].reduce(into: Array.init(repeating: [], count: 3)) {
        $0[$1.priority.rawValue].append($1)
    }
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

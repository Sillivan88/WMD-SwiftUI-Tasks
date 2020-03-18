//
//  TaskManager.swift
//  Tasks
//
//  Created by Thomas Sillmann on 17.03.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import Foundation

class TaskManager: ObservableObject {
    
    static let shared = TaskManager()
    
    @Published var tasks: [Task]
    
    var tasksSortedByTitle: [Task] {
        tasks.sorted { (firstTask, secondTask) -> Bool in
            firstTask.title < secondTask.title
        }
    }
    
    var tasksSortedByPriority: [Task] {
        tasksSortedByTitle.sorted { (firstTask, secondTask) -> Bool in
            firstTask.priority.rawValue > secondTask.priority.rawValue
        }
    }
    
    var defaultPriorityTasksAvailable: Bool {
        (tasks.first { (task) -> Bool in
            task.priority == .default
            } != nil)
    }
    
    var highPriorityTasksAvailable: Bool {
        (tasks.first { (task) -> Bool in
            task.priority == .high
            } != nil)
    }
    
    init(tasks: [Task] = [Task]()) {
        self.tasks = tasks
    }
    
    func createNewTask(withTitle title: String, priority: Task.Priority = .default, deadline: Date? = nil, notes: String? = nil, isFinished: Bool = false) {
        let task = Task(title: title, priority: priority, deadline: deadline, notes: notes, isFinished: isFinished)
        tasks.append(task)
    }
    
    func deleteTask(_ task: Task) {
        self.tasks.removeAll { (foundTask) -> Bool in
            foundTask.id == task.id
        }
    }
    
}

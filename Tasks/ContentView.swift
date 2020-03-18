//
//  ContentView.swift
//  Tasks
//
//  Created by Thomas Sillmann on 17.03.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showsAddTaskView = false
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        NavigationView {
            PickerTasksList()
            .navigationBarTitle("Tasks")
            .navigationBarItems(trailing: Button(action: {
                self.showsAddTaskView.toggle()
            }) {
                Text("Add")
            })
        }
        .sheet(isPresented: $showsAddTaskView) {
            AddTaskView(showsAddTaskView: self.$showsAddTaskView).environmentObject(self.taskManager)
        }
    }
}

enum TaskSorting: Int, Identifiable, CaseIterable {
    case title
    case priority
    
    var id: Int {
        rawValue
    }
    
    var formattedTitle: String {
        switch self {
        case .title:
            return "Title"
        case .priority:
            return "Priority"
        }
    }
}

struct PickerTasksList: View {
    @State private var sortingIndex = TaskSorting.title.rawValue
    
    var body: some View {
        VStack {
            SortingPicker(sortingIndex: $sortingIndex)
            SortedTasksList(sorting: TaskSorting.init(rawValue: sortingIndex)!)
        }
    }
}

struct SortingPicker: View {
    @Binding var sortingIndex: Int
    
    var body: some View {
        Picker("Sorting", selection: $sortingIndex) {
            ForEach(0 ..< TaskSorting.allCases.count) { sortingIndex in
                Text(TaskSorting.allCases[sortingIndex].formattedTitle)
            }
        }
        .padding()
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct SortedTasksList: View {
    var sorting: TaskSorting
    
    var body: some View {
        Group {
            if sorting == .priority {
                TasksSortedByPriorityList()
            } else {
                TasksSortedByTitleList()
            }
        }
    }
}

struct TasksSortedByTitleList: View {
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        List(taskManager.tasksSortedByTitle) { task in
            TaskCell(task: task)
        }
    }
}

struct TasksSortedByPriorityList: View {
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        List {
            if taskManager.highPriorityTasksAvailable {
                TasksPrioritySection(title: "High priority", priority: .high)
            }
            if taskManager.defaultPriorityTasksAvailable {
                TasksPrioritySection(title: "Default priority", priority: .default)
            }
        }
    }
}

struct TasksPrioritySection: View {
    let title: String
    
    let priority: Task.Priority
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        Section(header: Text(title)) {
            ForEach(taskManager.tasksSortedByTitle) { task in
                if task.priority == self.priority {
                    TaskCell(task: task)
                }
            }
        }
    }
}

struct TaskCell: View {
    @ObservedObject var task: Task

    var body: some View {
        NavigationLink(destination: TaskDetailView(task: task)) {
            HStack {
                Text(task.title)
                if task.isFinished {
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

struct AddTaskView: View {
    @Binding var showsAddTaskView: Bool
    
    @ObservedObject var task: Task = Task(title: "")
    
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        NavigationView {
            TaskDetailView(shouldUpdateTaskManager: false, task: task)
                .navigationBarItems(leading: Button(action: {
                    self.showsAddTaskView.toggle()
                }) {
                    Text("Cancel")
                        .bold()
                    }, trailing: Button(action: {
                        self.taskManager.createNewTask(withTitle: self.task.title, priority: self.task.priority, deadline: self.task.deadline, notes: self.task.notes, isFinished: self.task.isFinished)
                        self.showsAddTaskView.toggle()
                    }) {
                        Text("Save")
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

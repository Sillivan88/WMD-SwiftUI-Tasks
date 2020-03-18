//
//  TaskDetailView.swift
//  Tasks
//
//  Created by Thomas Sillmann on 18.03.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import SwiftUI

struct TaskDetailView: View {
    var shouldUpdateTaskManager = true
    
    @State private var showTaskDeletionAlert = false
    
    @ObservedObject var task: Task
    
    @EnvironmentObject var taskManager: TaskManager
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        let priorityBinding = Binding<Int>(get: {
            return self.task.priority.rawValue
        }, set: {
            self.task.priority = Task.Priority(rawValue: $0)!
            if self.shouldUpdateTaskManager {
                self.taskManager.objectWillChange.send()
            }
        })
        let notesBinding = Binding<String>(get: {
            if self.task.notes != nil {
                return self.task.notes!
            }
            return ""
        }, set: {
            self.task.notes = $0
        })
        return Form {
            Section(header: Text("Info")) {
                TextField("Title", text: $task.title)
                PriorityPicker(priorityIndex: priorityBinding)
                DeadlineView(task: task)
            }
            Section(header: Text("Notes")) {
                TextView(text: notesBinding)
                    .frame(height: 200)
            }
            Section {
                Button(action: {
                    self.task.isFinished.toggle()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text((self.task.isFinished) ? "Continue task" : "Finish task")
                        .foregroundColor((self.task.isFinished) ? .black : .green)
                }
                if shouldUpdateTaskManager {
                    Button(action: {
                        self.showTaskDeletionAlert.toggle()
                    }) {
                        Text("Delete task")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showTaskDeletionAlert, content: {
                        let cancelButton = Alert.Button.cancel()
                        let deleteButton = Alert.Button.destructive(Text("Delete")) {
                            self.taskManager.deleteTask(self.task)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        return Alert(title: Text("Delete task"), message: Text("Do you really want to delete this task?"), primaryButton: cancelButton, secondaryButton: deleteButton)
                    })
                }
            }
        }
        .navigationBarTitle(task.title)
    }
}

struct PriorityPicker: View {
    @Binding var priorityIndex: Int
    
    var body: some View {
        HStack {
            Text("Priority")
            Picker("Priority", selection: $priorityIndex) {
                ForEach(0 ..< Task.Priority.allCases.count) { sortingIndex in
                    Text(Task.Priority.allCases[sortingIndex].formattedTitle)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct DeadlineView: View {
    @State private var showDeadlinePicker = false
    
    @ObservedObject var task: Task

    var body: some View {
        let deadlineBinding = Binding<Date>(get: {
            if let deadline = self.task.deadline {
                return deadline
            }
            return Date()
        }, set: {
            self.task.deadline = $0
        })
        return VStack {
            Button(action: {
                self.showDeadlinePicker.toggle()
            }) {
                HStack {
                    Text("Deadline")
                        .foregroundColor(.black)
                    Spacer()
                    Text(task.formattedDeadline)
                        .foregroundColor((showDeadlinePicker) ? .blue : .gray)
                }
            }
            if showDeadlinePicker {
                VStack {
                    DatePicker(selection: deadlineBinding, displayedComponents: [.date], label: {
                        Text("")
                    })
                    .datePickerStyle(WheelDatePickerStyle())
                    Button(action: {
                        self.task.deadline = nil
                    }) {
                        Text("Remove deadline")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(task: Task(title: "Test"))
    }
}

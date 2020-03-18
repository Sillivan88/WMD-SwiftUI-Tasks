//
//  Task.swift
//  Tasks
//
//  Created by Thomas Sillmann on 17.03.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import Foundation

class Task: ObservableObject, Identifiable {
    
    enum Priority: Int, CaseIterable {
        case `default`
        case high
        
        var formattedTitle: String {
            switch self {
            case .`default`:
                return "Default"
            case .high:
                return "High"
            }
        }
    }
    
    var id = UUID()
    
    @Published var title: String
    
    @Published var priority: Priority
    
    @Published var deadline: Date?
    
    @Published var notes: String?
    
    @Published var isFinished: Bool
    
    var formattedDeadline: String {
        if let deadline = self.deadline {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: deadline)
        }
        return "No deadline"
    }
    
    init(title: String, priority: Priority = .default, deadline: Date? = nil, notes: String? = nil, isFinished: Bool = false) {
        self.title = title
        self.priority = priority
        self.deadline = deadline
        self.notes = notes
        self.isFinished = isFinished
    }
    
}

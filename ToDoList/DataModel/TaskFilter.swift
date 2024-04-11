//
//  TaskFilter.swift
//  ToDoList
//
//  Created by Sarah Alkhamees on 03/10/1445 AH.
//

import Foundation

enum TaskFilter: String, CaseIterable 
{
    case DueDate = "Due Date"
    case New = "New"
    case Done = "Done"
    
    var iconSymbols: String {
        switch self {
        case .DueDate:
            return "calendar.badge.clock"
        case .New:
            return "calendar"
        case .Done:
            return "calendar.badge.checkmark"
        }
    }
}

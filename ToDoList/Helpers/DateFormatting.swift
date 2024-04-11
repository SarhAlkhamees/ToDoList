//
//  DateFormatting.swift
//  ToDoList
//
//  Created by Sarah Alkhamees on 03/10/1445 AH.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm a"
    return dateFormatter.string(from: date)
}

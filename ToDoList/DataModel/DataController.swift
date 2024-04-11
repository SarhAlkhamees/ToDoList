//
//  DataController.swift
//  ToDoList
//
//  Created by Sarah Alkhamees on 02/10/1445 AH.
//

import Foundation
import CoreData

//Load, Change and Save the data
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TaskModel")
    
    init(){
        container.loadPersistentStores {description, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
            
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Date saved !!")
        } catch {
            print("We could not save the data...")
        }
    }
    
    func addTask(title: String, taskDescription: String, dueDate: Date, context: NSManagedObjectContext){
        let task = Task(context: context)
        task.id = UUID()
        task.date = Date()
        task.title = title
        task.taskDescription = taskDescription
        task.dueDate = dueDate
        task.isDone = false
        
        save(context: context)
    }
    
    func editTask(task: Task, title: String, taskDescription: String, dueDate: Date, context: NSManagedObjectContext){
        task.date = Date()
        task.title = title
        task.taskDescription = taskDescription
        task.dueDate = dueDate
        task.isDone = false
        
        save(context: context)
    }
}

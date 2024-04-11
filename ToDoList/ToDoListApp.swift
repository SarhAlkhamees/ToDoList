//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Sarah Alkhamees on 02/10/1445 AH.
//

import SwiftUI

@main
struct ToDoListApp: App {
    //Injecting the database
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

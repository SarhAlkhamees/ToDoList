//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Sarah Alkhamees on 03/10/1445 AH.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var taskDescription: String = ""
    @State private var dueDate: Date = .init()
    @State private var EmptyTitleAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    TextField("Enter the title",  text: $title)
                    TextField("Enter the description", text: $taskDescription)
                    DatePicker(selection: $dueDate, in: Date()..., displayedComponents: [.date, .hourAndMinute]){
                        Text("Due date")
                    }
                } header: {
                    Text("TASK INFO")
                } footer: {
                    Text("Assign info to your task to remind yourself later.")
                }
                
                Button {
                    if !(title.isEmpty) {
                        DataController().addTask(title: title, taskDescription: taskDescription, dueDate: dueDate, context: managedObjContext)
                        dismiss()
                    } else {
                        EmptyTitleAlert = true
                    }
                } label: {
                    Text("Add Task")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.borderless)
                .alert(isPresented: $EmptyTitleAlert){
                    Alert(title: Text("Error"), message: Text("Please enter the title"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    AddTaskView()
}

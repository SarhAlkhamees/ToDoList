//
//  ContentView.swift
//  ToDoList
//
//  Created by Sarah Alkhamees on 02/10/1445 AH.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var task: FetchedResults<Task>
    
    @State private var isShowingAddNewTaskView: Bool = false
    @State private var isShowingDeleteAllConfirmationDialog: Bool = false
    @State private var selectedFilter: TaskFilter = .Done
    
    private var filteredTasks: [Task] {
        switch selectedFilter {
        case .DueDate:
            return task.filter {$0.dueDate != nil}.sorted{$0.dueDate! < $1.dueDate!}
        case .New:
            return task.filter{$0.date != nil}.sorted{$0.date! < $1.date!}
        case .Done:
            return task.filter{$0.isDone}.sorted{$0.date! < $1.date!} +
            task.filter{!$0.isDone}.sorted{$0.date! < $1.date!}
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            NavigationStack{
                if filteredTasks.isEmpty{
                    Text("You don't have any tasks to do")
                }
                VStack(alignment: .leading, spacing: 6){
                    if filteredTasks.isEmpty{
                        Button(action: {
                            isShowingAddNewTaskView.toggle()
                        }, label: {
                            Image(systemName: "plus.circle.fill").resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                        })
                    } else {
                        List{
                            ForEach(filteredTasks){ task in
                                NavigationLink(destination: EditTaskView(task: task)){
                                    TaskItemCellView(task: task, selectedFilter: selectedFilter)
                                }
                            }
                            .onDelete(perform: deleteTask)
                        }
                        .listStyle(.plain)
                    }
                }
                .navigationTitle("To Do List")
                .toolbar{
                    if !filteredTasks.isEmpty{
                        //ToolbarItem for deleteing all the tasks
                        ToolbarItem(placement: .navigationBarLeading){
                            Button{
                                isShowingDeleteAllConfirmationDialog.toggle()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }.confirmationDialog("Delete Confirmation", isPresented: $isShowingDeleteAllConfirmationDialog, titleVisibility: .visible){
                                Button(role: .destructive){
                                    deleteAllTasks()
                                } label: {
                                    Text("Delete All")
                                }
                            } message: {
                                Text("Are you sure you want to remove all of the tasks?")
                            }
                        }
                        
                        //ToolbarItem for Edit
                        ToolbarItem(placement: .navigationBarTrailing){
                            EditButton()
                        }
                        
                        //ToolbarItem for Filtering
                        ToolbarItem(placement: .navigationBarTrailing){
                            Menu {
                                Picker("Select a filter", selection: $selectedFilter.animation()){
                                    ForEach(TaskFilter.allCases, id: \.self){ filter in
                                        Label(filter.rawValue, systemImage: filter.iconSymbols)
                                    }
                                }
                            } label: {
                                Image(systemName: "list.bullet")
                            }
                        }
                    }
                }.sheet(isPresented: $isShowingAddNewTaskView){
                    AddTaskView()
                }
            }
            if !filteredTasks.isEmpty{
                Button(action: {
                    isShowingAddNewTaskView.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                })
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteTask(offsets: IndexSet){
        withAnimation{
            offsets.map{filteredTasks[$0]}.forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    private func deleteAllTasks(){
        withAnimation{
            filteredTasks.forEach { task in
                managedObjContext.delete(task)
            }
            DataController().save(context: managedObjContext)
        }
    }
}
    
#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController().container.viewContext)
}
    
struct TaskItemCellView: View {
    @Environment(\.managedObjectContext) var managedObjContext
        
    var task: Task
    var selectedFilter: TaskFilter
        
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6){
                HStack{
                    Button(action:{ task.isDone.toggle()
                        DataController().save(context: managedObjContext)
                    }, label: {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    })
                    .buttonStyle(.borderless)
                    .padding(.trailing, 4)
                        
                    Text(task.title ?? "No title")
                        .bold()
                        .strikethrough(task.isDone, color: .gray)
                }
                Text("\(formatDate(task.dueDate ?? Date()))")
                    .strikethrough(task.isDone, color: .gray)
                    .font(.caption)
                    
                if selectedFilter == .New {
                    Text("Created At : \(formatDate(task.date ?? Date()))")
                        .strikethrough(task.isDone, color: .gray)
                        .font(.caption)
                }
            }
        }
    }
}

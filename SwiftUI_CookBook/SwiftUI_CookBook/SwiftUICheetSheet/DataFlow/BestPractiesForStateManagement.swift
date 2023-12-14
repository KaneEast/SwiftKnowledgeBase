//
//  BestPractiesForStateManagement.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/07.
//

import SwiftUI
/**
 Best Practices for State Management in SwiftUI
 
 Effective state management is key to building stable and responsive apps in SwiftUI. Below are some best practices for managing state in your SwiftUI apps:

 - Use State and Binding for simple local state. State and Binding are perfect for managing simple state that is local to a view or can be passed from a parent view to a child view. Keep in mind that these property wrappers are designed to work with value types.
 
 - Use ObservedObject and Published for complex state. When you have more complex state that can be shared across multiple views, consider using ObservedObject and Published in combination with a separate state management class.
 
 - Use EnvironmentObject for shared state across unrelated views. If you need to share state across multiple views that aren’t directly related through a parent-child relationship, EnvironmentObject can be a good choice.
 
 - Avoid large State variables. Storing large amounts of data in State variables can lead to performance issues, as SwiftUI recreates your view whenever state changes.
 
 - Defer complex computation and side effects. Avoid running complex computations or side effects, like network requests, directly in your view structures.
 */

class TaskManager: ObservableObject {
  @Published var tasks = [String]()

  func addTask(_ task: String) {
    tasks.append(task)
  }
}

struct TaskListView: View {
  @EnvironmentObject var taskManager: TaskManager
  @State private var newTask = ""

  var body: some View {
    NavigationStack {
      VStack {
        TextField("New task", text: $newTask)
          .onSubmit {
            if !newTask.isEmpty {
              taskManager.addTask(newTask)
              newTask = ""
            }
          }
          .padding()
        List(taskManager.tasks, id: \.self) { task in
          Text(task)
        }
      }
      .navigationTitle("Task List")
    }
  }
}

struct BestPractiesForStateManagementView: View {
  @StateObject var taskManager = TaskManager()
  
  var body: some View {
    TaskListView()
      .environmentObject(taskManager)
  }
}

#Preview {
  BestPractiesForStateManagementView()
}

/**
 In this example, you create a TaskManager class that manages a list of tasks. It’s an ObservableObject, which means that SwiftUI will watch for changes to its Published properties and update any views that depend on those properties. The TaskListView uses EnvironmentObject to access the shared TaskManager, and State for the newTask property that’s local to that view. When a new task is committed in the text field, the task is added to the task manager and the text field is cleared.
 */

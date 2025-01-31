import SwiftUI
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

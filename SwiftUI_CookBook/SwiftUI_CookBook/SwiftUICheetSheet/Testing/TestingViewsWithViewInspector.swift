//
//  TestingViewsWithViewInspector.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

/**
 ViewInspector is a powerful library for inspecting and testing SwiftUI views. This chapter demonstrates how to write tests for a simple to-do list app, showcasing how to use ViewInspector to verify the view hierarchy, modifiers and state.

 Adding the ViewInspector Package to a SwiftUI Project
 First, ensure your project has a unit testing suite. If it does not, add one by selecting File ▸ New ▸ Target and choosing the Unit Testing Bundle template.

 Next, add ViewInspector to your project through Swift Package Manager. To access the Swift Package Manager, go to File ▸ Add Packages… Then, enter the following URL and click Add Package:

 https://github.com/nalexn/ViewInspector

 Make sure to add the package to your unit testing target and NOT your main app target.

 Testing a To-Do List App
 Start by creating a simple model for to-do items:
 */
struct ToDoItem: Identifiable {
  let id = UUID()
  let title: String
  var isCompleted = false
}
class ToDoListViewModel: ObservableObject {
  @Published var items: [ToDoItem] = []

  func addItem(_ title: String) {
    items.append(ToDoItem(title: title))
  }

  func toggleCompletion(for item: ToDoItem) {
    if let index = items.firstIndex(where: { $0.id == item.id }) {
      items[index].isCompleted.toggle()
    }
  }
}
struct ToDoListContentView: View {
  @StateObject var viewModel = ToDoListViewModel()

  @State private var isAlertShowing = false
  @State private var itemDescriptionInput = ""

  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.items) { item in
          HStack {
            Text(item.title)
            Spacer()
            if item.isCompleted {
              Image(systemName: "checkmark")
            }
          }
          .onTapGesture { viewModel.toggleCompletion(for: item) }
        }
      }
      .navigationTitle("ToDo List")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { isAlertShowing.toggle() }, label: { Image(systemName: "plus") })
        }
      }
      .alert("Add a ToDo Item", isPresented: $isAlertShowing) {
        TextField("Item Description", text: $itemDescriptionInput)
        Button("Cancel", role: .cancel, action: clearInputs)
        Button("OK", action: addItem)
      }
    }
  }
  
  private func addItem() {
    viewModel.addItem(itemDescriptionInput)
    clearInputs()
  }

  private func clearInputs() {
    itemDescriptionInput = ""
  }
}

#Preview {
  ToDoListContentView()
}

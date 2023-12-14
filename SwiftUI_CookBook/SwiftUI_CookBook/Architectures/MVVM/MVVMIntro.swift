//
//  MVVMIntro.swift
//  SwiftUI_CookBook
//
//  Created by Kane on 2023/12/09.
//

import SwiftUI

/**
 mplement MVVM Architecture in SwiftUI
 Written by Team Kodeco
 MVVM is a design pattern that encourages a separation of concerns, making it easier to manage, test and extend your code. Here’s how it works:

 Model: The heart of the system, the model represents the application’s data structures and business logic. It’s responsible for managing the underlying data, enforcing rules and handling computations. The model is typically unaware of the user interface, ensuring a clear separation of concerns.

 View: The view defines the structure, layout and appearance of what the user sees on the screen. It displays data from the view model and sends user commands back to the view model. In MVVM, the view is often kept as simple and declarative as possible, making it easy to design and modify.

 View Model: Acting as a mediator between the model and the view, the view model handles the presentation logic and user interactions. It retrieves data from the model, transforming it into a format that can be easily displayed by the view. Conversely, it translates user actions into operations on the model, effectively decoupling the user interface from the underlying logic.

 Implementing the MVVM architecture in SwiftUI provides several advantages and some challenges. On the positive side, the pattern greatly enhances testability by allowing easy writing of unit tests for business logic, improves maintainability by enabling changes to appearance or functionality without affecting other parts of the code and offers reusability of views and view models across different areas of the app.

 This leads to a clean architecture with clear separation between UI and business logic, ease of testing without UI dependencies and flexibility to modify the UI without impacting the underlying logic.

 However, these benefits come with certain drawbacks. The complexity of MVVM might be overkill for very simple apps, and there may be a learning curve for those unfamiliar with concepts like bindings and observables.

 You’ll explore this approach below by building a virtual plant collection app.

 Model
 To start you’ll need a model to represent a plant:
 */
struct Plant: Identifiable {
  let id = UUID()
  var name: String
  var wateringFrequency: Int // days between watering
  var lastWateredDate: Date?
}
class PlantCollectionViewModel: ObservableObject {
  @Published var plants: [Plant] = []

  func addPlant(_ plant: Plant) {
    plants.append(plant)
  }

  func removePlant(_ plant: Plant) {
    plants.removeAll { $0.id == plant.id }
  }

  func updateWatering(for plant: Plant) {
    if let index = plants.firstIndex(where: { $0.id == plant.id }) {
      plants[index].lastWateredDate = Date()
    }
  }
}
struct MVVMIntro: View {
  @ObservedObject var viewModel = PlantCollectionViewModel()
  @State private var showingAddPlant = false
  @State private var plantNameInput = ""
  @State private var plantWaterFrequencyInput = 1

  var body: some View {
    NavigationStack {
      List {
        ForEach(viewModel.plants) { plant in
          HStack {
            Text(plant.name)
            Spacer()
            Text("Water every \(plant.wateringFrequency) days")
            Button(action: { viewModel.updateWatering(for: plant) }) {
              Image(systemName: "drop.fill")
            }
          }
        }
        .onDelete(perform: deletePlant)
      }
      .navigationTitle("My Plants")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: { showingAddPlant.toggle() }) {
            Image(systemName: "plus")
          }
        }
      }
      .alert("Add Plant", isPresented: $showingAddPlant) {
        TextField("Plant Name", text: $plantNameInput)
        TextField("Water Frequency", value: $plantWaterFrequencyInput, formatter: NumberFormatter())
        Button("OK", action: addPlant)
        Button("Cancel", role: .cancel, action: clearInputs)
      }
    }
  }

  private func deletePlant(at offsets: IndexSet) {
    offsets.forEach { viewModel.removePlant(viewModel.plants[$0]) }
  }

  private func addPlant() {
    viewModel.addPlant(
      Plant(
        name: plantNameInput,
        wateringFrequency: plantWaterFrequencyInput
      )
    )

    clearInputs()
  }

  private func clearInputs() {
    plantNameInput = ""
    plantWaterFrequencyInput = 1
  }
}

#Preview {
    MVVMIntro()
}

/**
 Here’s what’s going on:

 ViewModel Binding: Utilizes PlantCollectionViewModel for underlying logic and data.
 State Variables: Manages UI state for adding plants (showingAddPlant, plantNameInput, plantWaterFrequencyInput).
 NavigationStack: Wraps list and navigation controls.
 List with ForEach: Displays plants, iterating over the collection.
 HStack in List: Shows plant name, watering frequency, and watering button.
 Toolbar: Contains edit and add buttons; leading for editing and trailing for addition.
 Alert for Adding Plant: Collects user input for plant name and watering frequency.
 Private Functions: Includes deletePlant, addPlant, and clearInputs for managing plant collection.
 Interactions: Enables adding, deleting and updating watering details for plants.
 These elements combine to form an interface that allows users to manage a collection of plants, following the principles of the MVVM architecture pattern.

 By building a Virtual Plant Collection app using the MVVM architecture, you have gained hands-on experience with this design pattern in SwiftUI. This simple yet effective example demonstrates how you can cleanly separate logic and UI, making it easier to maintain and test your code. Feel free to enhance the app by adding features like plant categories, growth stages or even virtual watering and fertilization functionalities. Happy coding and cultivating your virtual garden!
 */

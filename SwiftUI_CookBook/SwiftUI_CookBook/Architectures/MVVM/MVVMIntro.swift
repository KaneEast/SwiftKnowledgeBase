import SwiftUI
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

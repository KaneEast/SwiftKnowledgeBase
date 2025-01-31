import Foundation
import SwiftUI
import PhotosUI
struct PhotosPickerView: View {
  @State private var selectedItems = [PhotosPickerItem]()
  @State private var images = [UUID: Image]()

  var body: some View {
    ZStack {
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
          ForEach(Array(images.keys), id: \.self) { key in
            images[key]!
              .resizable()
              .scaledToFill()
              .frame(width: 100, height: 100)
              .clipped()
          }
        }
      }

      VStack {
        Spacer()
        PhotosPicker(selection: $selectedItems, matching: .images) {
          Text("Select Images")
        }
        .task(id: selectedItems, {
          await loadImages(from: selectedItems)
        })
        Spacer()
      }
    }
  }

  private func loadImages(from items: [PhotosPickerItem]) async {
    for item in items {
      do {
        let image = try await item.loadTransferable(type: Image.self)
        if let image = image {
          images[UUID()] = image
        }
      } catch {
        print("Failed to load image: \(error)")
      }
    }
  }
}

#Preview {
  PhotosPickerView()
}

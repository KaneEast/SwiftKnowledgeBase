import SwiftUI
struct GridView: View {
  let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(items, id: \.self) { item in
        Text(item)
          .frame(maxWidth: .infinity)
          .frame(height: 100)
          .background(.blue)
          .foregroundColor(.white)
      }
    }
    .padding()
  }
}
struct LazyVGrid1: View {
  var body: some View {
    // Define your grid layout first
    let columns = [
      GridItem(.fixed(100)),
      GridItem(.flexible()),
      GridItem(.flexible())
    ]
    // Then create a LazyVGrid using the layout
    LazyVGrid(columns: columns, spacing: 20) {
      ForEach(0..<10) { index in
        Text("Item \(index)")
          .padding()
          .background(Color.blue)
          .cornerRadius(10)
      }
    }
  }
}
struct ScrollViewView: View {
  var body: some View {
    VStack {
      // Vertical ScrollView
      ScrollView(.vertical) {
        VStack(spacing: 20) {
          ForEach(1...20, id: \.self) { index in
            Text("Row \(index)")
              .font(.title)
          }
        }
        .padding()
        .frame(maxWidth: .infinity)
      }

      Divider()

      // Horizontal ScrollView
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
          ForEach(1...20, id: \.self) { index in
            Text("Item \(index)")
              .font(.title)
          }
        }
        .padding()
      }
    }
  }
}
struct ZVStackView: View {
  var body: some View {
    ZStack {
      VStack {
        Text("Top")
          .padding()
          .background(Color.green)
        Spacer()
          .frame(height: 20)
        Text("Middle")
          .padding()
          .background(Color.yellow)
        Spacer()
          .frame(height: 20)
        Text("Bottom")
          .padding()
          .background(Color.red)
      }

      Image(systemName: "sun.max.fill")
        .resizable()
        .frame(width: 100, height: 100)
        .foregroundColor(.orange)
    }
  }
}
#Preview {
  ScrollView {
    VStack {
      GridView()
      LazyVGrid1()
      ScrollViewView().frame(height: 300)
      ZVStackView()
    }
  }
}

import SwiftUI
struct BlueView: View {
  var body: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.blue)
  }
}

struct RedView: View {
  var body: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.red)
  }
}

struct GreenView: View {
  var body: some View {
    Rectangle()
      .frame(width: 50, height: 50)
      .foregroundColor(.green)
  }
}

struct ViewComposition: View {
  var body: some View {
    VStack {
      BlueView()
      RedView()
      GreenView()
    }
  }
}

#Preview {
    ViewComposition()
}

import SwiftUI
struct DebuggingViews: View {
  @State private var count = 0

  var body: some View {
    Button("Tap Me") {
      count += 1
      print("Button tapped \(count) times.")

      if count > 10 {
        assertionFailure("Button was tapped too many times!")
      }
    }
  }
}
#Preview {
    DebuggingViews()
}

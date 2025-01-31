import SwiftUI

struct BoldAndItalicModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .fontWeight(.bold)
      .italic()
  }
}

#Preview {
  Text("Hello, World!")
    .modifier(BoldAndItalicModifier())
}
